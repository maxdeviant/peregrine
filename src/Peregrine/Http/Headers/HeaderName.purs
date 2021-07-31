module Peregrine.Http.Headers.HeaderName where

import Prelude
import Data.Newtype (class Newtype, unwrap)
import Data.String.NonEmpty as NonEmptyString
import Data.String.NonEmpty.CaseInsensitive (CaseInsensitiveNonEmptyString(..))
import Data.String.NonEmpty.Internal (NonEmptyString(..))
import Data.Symbol (class IsSymbol, reflectSymbol)
import Prim.TypeError as TypeError

-- The name of an HTTP header.
newtype HeaderName
  = HeaderName CaseInsensitiveNonEmptyString

derive instance newtypeHeaderName :: Newtype HeaderName _

derive newtype instance eqHeaderName :: Eq HeaderName

derive newtype instance ordHeaderName :: Ord HeaderName

instance showHeaderName :: Show HeaderName where
  show = NonEmptyString.toString <<< unwrap <<< unwrap

-- | A helper class for defining header names at compile time.
-- |
-- | ```purescript
-- | contentType :: HeaderName
-- | contentType = staticHeaderName (Proxy :: Proxy "Content-Type")
-- | ```
class MakeHeaderName (s :: Symbol) where
  staticHeaderName :: forall proxy. proxy s -> HeaderName

instance makeHeaderNameBad ::
  TypeError.Fail (TypeError.Text "Header name must be a non-empty string.") =>
  MakeHeaderName "" where
  staticHeaderName _ =
    HeaderName
      $ CaseInsensitiveNonEmptyString
      $ NonEmptyString ""
else instance makeHeaderNameGood :: IsSymbol s => MakeHeaderName s where
  staticHeaderName proxy =
    HeaderName
      $ CaseInsensitiveNonEmptyString
      $ NonEmptyString
      $ reflectSymbol proxy
