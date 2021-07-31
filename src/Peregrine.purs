module Peregrine where

import Prelude
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Data.Newtype (unwrap)
import Data.String.NonEmpty as NonEmptyString
import Data.TraversableWithIndex (traverseWithIndex)
import Effect (Effect)
import Effect.Aff (Aff, runAff)
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import Node.HTTP as Http
import Peregrine.Headers (Headers(..))
import Peregrine.Request (Request)
import Peregrine.Response (Response)
import Peregrine.Status (Status)
import Peregrine.Status as Status

type Handler
  = Request -> Aff Response

type RequestListener
  = Http.Request -> Http.Response -> Effect Unit

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
  setHeader key value = Http.setHeader res (NonEmptyString.toString $ unwrap key) value

writeResponse :: Http.Response -> Response -> Aff Unit
writeResponse res response = do
  let
    status = response.status # fromMaybe Status.ok
  liftEffect $ writeStatus res status
  liftEffect $ writeHeaders res response.headers
  liftAff $ maybe (pure unit) ((#) res) response.writeBody

mkRequestListener :: Handler -> RequestListener
mkRequestListener handler _req res = do
  _ <-
    runAff (\_ -> pure unit)
      $ handler { method: "GET" }
      >>= writeResponse res
  pure unit

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
