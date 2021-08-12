module Examples.HelloWorld where

import Prelude
import Data.Array (intercalate)
import Data.Maybe (Maybe(..), maybe)
import Data.String.Utils (lines)
import Effect (Effect)
import Effect.Class.Console (log)
import Peregrine (Handler, Middleware, choose)
import Peregrine as Peregrine
import Peregrine.Http.Headers (HeaderName, staticHeaderName)
import Peregrine.Http.Headers as Headers
import Peregrine.Http.Status (Status)
import Peregrine.Response as Response
import Peregrine.Routing (path)
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
    log $ "URL: " <> req'.url
    log $ "Path: " <> req'.path
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
    Just _ -> pure $ Just Response.unauthorized
    Nothing -> pure $ Just Response.unauthorized
  where
  authorization = staticHeaderName (Proxy :: Proxy "Authorization")

helloWorld :: Handler
helloWorld req =
  pure $ Just
    $ Response.ok
    # Response.addHeader contentType "text/plain"
    # Response.text (greeting req)
  where
  greeting { method, url } =
    "Hello, world from a "
      <> show method
      <> " to "
      <> url
      <> "!"

admin :: Handler
admin _req =
  pure $ Just
    $ Response.ok
    # Response.text "Welcome to the admin panel."

app :: Handler
app =
  choose
    [ path "/" $ helloWorld
    , path
        "/admin"
        $ requireAuthorization admin
    ]

main :: Effect (Effect Unit -> Effect Unit)
main =
  Peregrine.fly app' do
    log "Peregrine server listening at http://localhost:3000"
  where
  app' = loggingMiddleware app
