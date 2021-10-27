module Peregrine.Request.FromParam
  ( class FromParam
  , fromParam
  ) where

import Prelude
import Data.Either (Either(..), note)
import Data.Int as Int
import Data.Maybe (Maybe(..))
import Data.Number as Number
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString

class FromParam a where
  fromParam :: String -> Either String a

instance fromParamString :: FromParam String where
  fromParam = Right

instance fromParamInt :: FromParam Int where
  fromParam param = Int.fromString >>> note param $ param

instance fromParamNumber :: FromParam Number where
  fromParam param = Number.fromString >>> note param $ param

instance fromParamBoolean :: FromParam Boolean where
  fromParam = case _ of
    "true" -> Right true
    "false" -> Right false
    param -> Left param

instance fromParamNonEmptyString :: FromParam NonEmptyString where
  fromParam param = NonEmptyString.fromString >>> note param $ param

instance fromParamMaybe :: FromParam a => FromParam (Maybe a) where
  fromParam =
    fromParam
      >>> case _ of
        Right value -> Right $ Just value
        Left _ -> Right Nothing

instance fromParamEither :: FromParam a => FromParam (Either String a) where
  fromParam =
    fromParam
      >>> case _ of
        Right value -> Right $ Right value
        Left param -> Right $ Left param
