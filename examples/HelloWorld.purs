module Examples.HelloWorld where

import Prelude
import Data.Argonaut.Decode (JsonDecodeError, printJsonDecodeError)
import Data.Array (intercalate)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Data.String.Utils (lines)
import Effect (Effect)
import Effect.Class.Console (log)
import Peregrine (Middleware, Handler, choose)
import Peregrine as Peregrine
import Peregrine.Body (contentLengthLimit, tryJson)
import Peregrine.Http.HeaderName as HeaderName
import Peregrine.Http.Headers as Headers
import Peregrine.Http.Method (Method(..))
import Peregrine.Http.Status (Status)
import Peregrine.Request as Request
import Peregrine.Response as Response
import Peregrine.Response.Body as Body
import Peregrine.Routing (method, path)

loggingMiddleware :: Middleware
loggingMiddleware handler originalReq = do
  req <- logRequest originalReq
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
    log "Body:"
    { body, req': req } <- Request.parseBody req'
    log body
    pure req

  logResponse res = do
    log "Returning response"
    res.status # maybe (pure unit) (log <<< showStatus)
    log "Headers:"
    log $ indentLines $ show res.headers
    log "Body:"
    res.body # maybe (log "<None>") (log <<< Body.toString)
    where
    showStatus :: Status -> String
    showStatus { code, reason } = show code <> " " <> reason

  indentLines = lines >>> map (\line -> "  " <> line) >>> intercalate "\n"

requireAuthorization :: Middleware
requireAuthorization handler req = do
  let
    authorizationValue = req.headers # Headers.lookup HeaderName.authorization
  case authorizationValue of
    Just "Bearer open_sesame" -> handler req
    Just _ -> pure $ Just Response.unauthorized
    Nothing -> pure $ Just Response.unauthorized

helloWorld :: Handler
helloWorld req =
  pure $ Just
    $ Response.ok
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

type NewTodo =
  { name :: String
  , completed :: Maybe Boolean
  }

type Todo =
  { name :: String
  , completed :: Boolean
  }

createTodo :: Either JsonDecodeError NewTodo -> Handler
createTodo eitherNewTodo _req = do
  case eitherNewTodo of
    Right newTodo ->
      let
        todo = { name: newTodo.name, completed: fromMaybe false newTodo.completed }
      in
        pure $ Just $ Response.ok # Response.json todo
    Left err ->
      pure $ Just $ Response.badRequest # Response.json { message: printJsonDecodeError err }

app :: Handler
app =
  choose
    [ path "/" $ helloWorld
    , path "/todos"
        $ method Post
        $ contentLengthLimit (32 * 1024)
        $ tryJson createTodo
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
