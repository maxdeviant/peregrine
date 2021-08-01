module Peregrine.Routing where

import Prelude
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), stripPrefix)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Peregrine (Handler)
import Peregrine.Http.Method (Method)

method :: Method -> Handler -> Handler
method method' next req = do
  if req.method == method' then
    next req
  else
    pure Nothing

path :: String -> Handler -> Handler
path path' next req = do
  liftEffect $ log $ "Checking " <> req.path <> " == " <> path'
  if req.path == path' then
    next req
  else
    pure Nothing

pathPrefix :: String -> Handler -> Handler
pathPrefix prefix next req = do
  case req.path # stripPrefix (Pattern prefix) of
    Just remainingPath -> next $ req { path = remainingPath }
    Nothing -> pure Nothing