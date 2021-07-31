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
import Peregrine.Response.Body as Body
import Type.Proxy (Proxy(..))

contentType :: HeaderName
contentType = staticHeaderName (Proxy :: Proxy "Content-Type")

loggingMiddleware :: Middleware
loggingMiddleware handler req = do
  logRequest req
  response <- handler req
  logResponse response
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

helloWorld :: Handler
helloWorld req = do
  pure
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
  app = loggingMiddleware helloWorld
