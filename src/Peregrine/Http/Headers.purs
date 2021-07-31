module Peregrine.Http.Headers
  ( Headers(..)
  , empty
  , insert
  , HeaderValue
  -- Re-exports
  , module HeaderName
  ) where

import Prelude
import Data.Map (Map)
import Data.Map as Map
import Data.Newtype (class Newtype)
import Peregrine.Http.Headers.HeaderName (HeaderName)
import Peregrine.Http.Headers.HeaderName (class MakeHeaderName, HeaderName(..), staticHeaderName) as HeaderName

type HeaderValue
  = String

newtype Headers
  = Headers (Map HeaderName HeaderValue)

derive instance newtypeHeaders :: Newtype Headers _

empty :: Headers
empty = Headers Map.empty

insert :: HeaderName -> HeaderValue -> Headers -> Headers
insert name value (Headers headers) = Headers $ Map.insert name value headers
