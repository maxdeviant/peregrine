module Peregrine.Headers where

import Prelude
import Data.Map (Map)
import Data.Map as Map
import Data.Newtype (class Newtype)
import Data.String.NonEmpty.CaseInsensitive (CaseInsensitiveNonEmptyString)

type HeaderName
  = CaseInsensitiveNonEmptyString

type HeaderValue
  = String

newtype Headers
  = Headers (Map HeaderName HeaderValue)

derive instance newtypeHeaders :: Newtype Headers _

empty :: Headers
empty = Headers Map.empty

insert :: HeaderName -> HeaderValue -> Headers -> Headers
insert name value (Headers headers) = Headers $ Map.insert name value headers
