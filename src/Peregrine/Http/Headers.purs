module Peregrine.Http.Headers
  ( Headers(..)
  , empty
  , singleton
  , insert
  , lookup
  , HeaderValue
  -- Re-exports
  , module HeaderName
  ) where

import Prelude
import Data.Array (intercalate)
import Data.Map (Map, toUnfoldable)
import Data.Map as Map
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)
import Data.Tuple (Tuple(..))
import Peregrine.Http.Headers.HeaderName (HeaderName)
import Peregrine.Http.Headers.HeaderName (class MakeHeaderName, HeaderName(..), staticHeaderName) as HeaderName

type HeaderValue
  = String

newtype Headers
  = Headers (Map HeaderName HeaderValue)

derive instance newtypeHeaders :: Newtype Headers _

instance showHeaders :: Show Headers where
  show (Headers headers) =
    headers
      # toUnfoldable
      # map showHeader
      # intercalate "\n"
    where
    showHeader (Tuple name value) = show name <> ": " <> value

derive newtype instance eqHeaders :: Eq Headers

instance semigroupHeaders :: Semigroup Headers where
  append (Headers headers) (Headers headers') = Headers $ Map.union headers' headers

empty :: Headers
empty = Headers Map.empty

singleton :: HeaderName -> HeaderValue -> Headers
singleton name value = Headers $ Map.singleton name value

insert :: HeaderName -> HeaderValue -> Headers -> Headers
insert name value (Headers headers) = Headers $ Map.insert name value headers

lookup :: HeaderName -> Headers -> Maybe HeaderValue
lookup name (Headers headers) = headers # Map.lookup name
