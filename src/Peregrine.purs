module Peregrine where

import Prelude
import Data.Array (head, uncons)
import Data.Either (Either, either, note)
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Data.String (Pattern(..), split)
import Data.TraversableWithIndex (traverseWithIndex)
import Effect (Effect)
import Effect.Aff (Aff, runAff)
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import Foreign.Object as Object
import Node.HTTP as Http
import Peregrine.Http.Headers (Headers(..))
import Peregrine.Http.Headers as Headers
import Peregrine.Http.Headers.HeaderName as HeaderName
import Peregrine.Http.Method (Method)
import Peregrine.Http.Method as Method
import Peregrine.Http.Status (Status)
import Peregrine.Http.Status as Status
import Peregrine.Request (Request)
import Peregrine.Response (Response)
import Peregrine.Response.Body as Body

type Handler
  = Request -> Aff (Maybe Response)

type Middleware
  = Handler -> Handler

type RequestListener
  = Http.Request -> Http.Response -> Effect Unit

choose :: Array Handler -> Handler
choose handlers req = do
  case uncons handlers of
    Just { head, tail } -> do
      maybeRes <- req # head
      case maybeRes of
        Just res -> pure $ Just res
        Nothing -> choose tail req
    Nothing -> pure Nothing

parseMethod :: Http.Request -> Either String Method
parseMethod req = do
  let
    requestMethod = req # Http.requestMethod
  requestMethod
    # Method.fromString
    # note ("Invalid HTTP method: '" <> requestMethod <> "'.")

parseUrl :: Http.Request -> String
parseUrl = Http.requestURL

parseHeaders :: Http.Request -> Headers
parseHeaders = Http.requestHeaders >>> Object.foldMaybe tryInsert Headers.empty
  where
  tryInsert headers key value = do
    name <- key # HeaderName.fromString
    pure $ headers # Headers.insert name value

parseRequest :: Http.Request -> Either String Request
parseRequest req = do
  method <- req # parseMethod
  let
    url = req # parseUrl
  pure
    { method
    , url
    , path: url # split (Pattern "?") >>> head >>> fromMaybe ""
    , headers: req # parseHeaders
    }

writeStatus :: Http.Response -> Status -> Effect Unit
writeStatus res { code, reason } = do
  _ <- Http.setStatusCode res code
  _ <- Http.setStatusMessage res reason
  pure unit

writeHeaders :: Http.Response -> Headers -> Effect Unit
writeHeaders res (Headers headers) =
  void
    $ traverseWithIndex setHeader headers
  where
  setHeader key value = Http.setHeader res (show key) value

writeResponse :: Http.Response -> Response -> Aff Unit
writeResponse res response = do
  let
    status = response.status # fromMaybe Status.ok
  liftEffect $ writeStatus res status
  liftEffect $ writeHeaders res response.headers
  liftAff $ maybe (pure unit) ((#) res) response.writeBody

mkRequestListener :: Handler -> RequestListener
mkRequestListener handler req res = do
  _ <-
    runAff (\_ -> pure unit) do
      maybeResponse <- req # parseRequest # either errorHandler handler
      let
        response = maybeResponse # fromMaybe notFoundResponse
      response # writeResponse res
  pure unit
  where
  notFoundResponse =
    { status: Just Status.notFound
    , headers: Headers.empty
    , writeBody: Just $ Body.write Status.notFound.reason
    }

  errorHandler :: String -> Aff (Maybe Response)
  errorHandler message =
    pure
      $ pure
          { status: Just Status.internalServerError
          , headers: Headers.empty
          , writeBody: Just $ Body.write message
          }

defaultListenOptions :: Http.ListenOptions
defaultListenOptions =
  { hostname: "0.0.0.0"
  , port: 3000
  , backlog: Nothing
  }

fly :: Handler -> Effect Unit -> Effect (Effect Unit -> Effect Unit)
fly handler callback = do
  server <- Http.createServer $ mkRequestListener handler
  Http.listen server defaultListenOptions callback
  pure $ Http.close server
