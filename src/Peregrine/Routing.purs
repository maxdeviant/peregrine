module Peregrine.Routing where

import Prelude
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), stripPrefix)
import Peregrine (Handler)
import Peregrine.Http.Headers (HeaderName, HeaderValue)
import Peregrine.Http.Headers as Headers
import Peregrine.Http.Method (Method)

method :: Method -> Handler -> Handler
method method' next req = do
  if req.method == method' then
    next req
  else
    pure Nothing

path :: String -> Handler -> Handler
path path' next req = do
  if req.path == path' then
    next req
  else
    pure Nothing

pathPrefix :: String -> Handler -> Handler
pathPrefix prefix next req = do
  case req.path # stripPrefix (Pattern prefix) of
    Just remainingPath -> next $ req { path = remainingPath }
    Nothing -> pure Nothing

header :: forall a. HeaderName -> (HeaderValue -> Maybe a) -> (a -> Handler) -> Handler
header name parseValue next req = do
  case req.headers # Headers.lookup name >>= parseValue of
    Just value -> next value req
    Nothing -> pure Nothing
