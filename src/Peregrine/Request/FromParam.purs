module Peregrine.Request.FromParam where

import Data.Int as Int
import Data.Maybe (Maybe(..))
import Data.Number as Number
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString

class FromParam a where
  fromParam :: String -> Maybe a

instance fromParamString :: FromParam String where
  fromParam = Just

instance fromParamInt :: FromParam Int where
  fromParam = Int.fromString

instance fromParamNumber :: FromParam Number where
  fromParam = Number.fromString

instance fromParamBoolean :: FromParam Boolean where
  fromParam = case _ of
    "true" -> Just true
    "false" -> Just false
    _ -> Nothing

instance fromParamNonEmptyString :: FromParam NonEmptyString where
  fromParam = NonEmptyString.fromString

instance fromParamMaybe :: (FromParam a) => FromParam (Maybe a) where
  fromParam = fromParam
