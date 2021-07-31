module Peregrine.Http.Method where

import Prelude
import Data.Maybe (Maybe(..))

-- | An HTTP request method.
data Method
  = Get
  | Put
  | Post
  | Delete
  | Options
  | Head
  | Trace
  | Connect
  | Patch

derive instance eqMethod :: Eq Method

instance showMethod :: Show Method where
  show = case _ of
    Get -> "GET"
    Put -> "PUT"
    Post -> "POST"
    Delete -> "DELETE"
    Options -> "OPTIONS"
    Head -> "HEAD"
    Trace -> "TRACE"
    Connect -> "CONNECT"
    Patch -> "PATCH"

fromString :: String -> Maybe Method
fromString = case _ of
  "GET" -> Just Get
  "PUT" -> Just Put
  "POST" -> Just Post
  "DELETE" -> Just Delete
  "OPTIONS" -> Just Options
  "HEAD" -> Just Head
  "TRACE" -> Just Trace
  "CONNECT" -> Just Connect
  "PATCH" -> Just Patch
  _ -> Nothing

-- | Returns whether an HTTP request with the indicated method always supports
-- | a payload.
-- |
-- | The following methods always support payloads:
-- | - `PUT`
-- | - `POST`
-- | - `DELETE`
-- | - `PATCH`
-- |
-- | The following methods do **not** always support payloads:
-- | - `GET`
-- | - `HEAD`
-- | - `CONNECT`
-- | - `TRACE`
-- | - `OPTIONS`
alwaysSupportsPayload :: Method -> Boolean
alwaysSupportsPayload = case _ of
  Put -> true
  Post -> true
  Delete -> true
  Patch -> true
  Get -> false
  Head -> false
  Connect -> false
  Trace -> false
  Options -> false
