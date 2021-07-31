module Examples.HelloWorld where

import Prelude
import Data.Array (intercalate)
import Data.Maybe (Maybe(..), maybe)
import Data.String.Utils (lines)
import Effect (Effect)
import Effect.Class.Console (log)
import Peregrine (Handler, Middleware)
import Peregrine as Peregrine
import Peregrine.Http.Headers (HeaderName, staticHeaderName)
import Peregrine.Http.Headers as Headers
import Peregrine.Http.Status (Status)
import Peregrine.Http.Status as Status
import Peregrine.Response (Response)
import Peregrine.Response.Body as Body
import Type.Proxy (Proxy(..))

contentType :: HeaderName
contentType = staticHeaderName (Proxy :: Proxy "Content-Type")

loggingMiddleware :: Middleware
loggingMiddleware handler req = do
  logRequest req
  response <- handler req
  response # maybe (pure unit) logResponse
  pure response
  where
  logRequest req' = do
    log "Received request"
    log $ "Method: " <> show req'.method
    log "Headers:"
    log $ indentLines $ show req'.headers

  logResponse res = do
    log "Returning response"
    res.status # maybe (pure unit) (log <<< showStatus)
    log "Headers:"
    log $ indentLines $ show res.headers
    where
    showStatus :: Status -> String
    showStatus { code, reason } = show code <> " " <> reason

  indentLines = lines >>> map (\line -> "  " <> line) >>> intercalate "\n"

requireAuthorization :: Middleware
requireAuthorization handler req = do
  let
    authorizationValue = req.headers # Headers.lookup authorization
  case authorizationValue of
    Just "Bearer open_sesame" -> handler req
    Just _ -> pure $ Just unauthorized
    Nothing -> pure $ Just unauthorized
  where
  authorization = staticHeaderName (Proxy :: Proxy "Authorization")

  unauthorized :: Response
  unauthorized =
    { status: Just Status.unauthorized
    , headers: Headers.empty
    , writeBody: Just $ Body.write Status.unauthorized.reason
    }

helloWorld :: Handler
helloWorld req = do
  pure $ pure
    $ { status: Just Status.ok
      , headers: Headers.empty # Headers.insert contentType "text/plain"
      , writeBody:
          Just $ Body.write $ greeting req
      }
  where
  greeting { method, url } =
    "Hello, world from a "
      <> show method
      <> " to "
      <> url
      <> "!"

main :: Effect (Effect Unit -> Effect Unit)
main =
  Peregrine.fly app do
    log "Peregrine server listening at http://localhost:3000"
  where
  app = loggingMiddleware <<< requireAuthorization $ helloWorld
