module Peregrine.Routing where

import Prelude
import Data.Array as Array
import Data.Array.NonEmpty as NonEmptyArray
import Data.Either (Either(..))
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), Replacement(..), stripPrefix)
import Data.String as String
import Data.String.Regex as Regex
import Data.String.Regex.Flags (noFlags)
import Data.Tuple (Tuple(..))
import Peregrine (Handler)
import Peregrine.Http.Headers (HeaderName, HeaderValue)
import Peregrine.Http.Headers as Headers
import Peregrine.Http.Method (Method)
import Peregrine.Response as Response

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

pathParams :: forall params. String -> (Map String String -> Maybe params) -> (params -> Handler) -> Handler
pathParams path' parseParams next req = do
  case Regex.regex pattern noFlags of
    Right regex -> case Regex.match regex req.path of
      Just matches ->
        let
          matchesWithGroupNames =
            Array.zip groupNames
              $ NonEmptyArray.drop 1 matches

          params =
            matchesWithGroupNames
              # Array.mapMaybe
                  ( \(Tuple name match) ->
                      match
                        # map \match' -> Tuple name match'
                  )
              # Map.fromFoldable
              # parseParams
        in
          case params of
            Just params' -> next params' req
            Nothing -> pure Nothing
      Nothing -> pure Nothing
    Left error ->
      pure
        $ Just
        $ Response.internalServerError
        # Response.withBody error
  where
  groupNames =
    path'
      # String.split (Pattern "/")
      # Array.filter (String.contains (Pattern "<"))
      # map
          ( String.replace (Pattern "<") (Replacement "")
              >>> String.replace (Pattern ">") (Replacement "")
          )

  pattern =
    path'
      # String.replaceAll (Pattern "<") (Replacement "(?<")
      # String.replaceAll (Pattern ">") (Replacement ">[^/\n]+)")
      # (\p -> "^" <> p <> "$")

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
