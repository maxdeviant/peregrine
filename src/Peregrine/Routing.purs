module Peregrine.Routing
  ( method
  , path
  , pathPrefix
  , pathParam
  , pathParams1
  , pathParams2
  , pathParams3
  , header
  ) where

import Prelude
import Data.Array (uncons)
import Data.Array.NonEmpty as NonEmptyArray
import Data.Either (Either(..), hush)
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), Replacement(..), stripPrefix)
import Data.String as String
import Data.String.Regex as Regex
import Data.String.Regex.Flags (noFlags)
import Effect.Aff (Aff)
import Peregrine (Handler)
import Peregrine.Http.Headers (HeaderName, HeaderValue)
import Peregrine.Http.Headers as Headers
import Peregrine.Http.Method (Method)
import Peregrine.Request.FromParam (class FromParam, fromParam)
import Peregrine.Response (Response)
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

pathPrefix :: String -> Handler -> Handler
pathPrefix prefix next req = do
  case req.path # stripPrefix (Pattern prefix) of
    Just remainingPath -> next $ req { path = remainingPath }
    Nothing -> pure Nothing

matchPath :: String → String → Either String (Maybe (Array (Maybe String)))
matchPath path' requestPath =
  Regex.regex pattern noFlags
    # map \regex ->
        Regex.match regex requestPath
          # map (NonEmptyArray.drop 1)
  where
  pattern =
    path'
      # String.replaceAll (Pattern "<") (Replacement "(?<")
      # String.replaceAll (Pattern ">") (Replacement ">[^/\n]+)")
      # (\p -> "^" <> p <> "$")

reportError :: String -> Aff (Maybe Response)
reportError error =
  pure
    $ Just
    $ Response.internalServerError
    # Response.text error

-- | An alias for `pathParams1`.
pathParam ::
  forall a.
  FromParam a =>
  String -> (a -> Handler) -> Handler
pathParam = pathParams1

pathParams1 ::
  forall a.
  FromParam a =>
  String -> (a -> Handler) -> Handler
pathParams1 path' next req = do
  case matchPath path' req.path of
    Right maybeMatches -> case maybeMatches of
      Just matches ->
        do
          { head: a', tail: _as } <- uncons matches
          a <- a' >>= fromParam >>> hush
          Just { a }
          # case _ of
              Just { a } -> next a req
              Nothing -> pure Nothing
      Nothing -> pure Nothing
    Left error -> reportError error

pathParams2 ::
  forall a b.
  FromParam a =>
  FromParam b =>
  String -> (a -> b -> Handler) -> Handler
pathParams2 path' next req = do
  case matchPath path' req.path of
    Right maybeMatches -> case maybeMatches of
      Just matches ->
        do
          { head: a', tail: as } <- uncons matches
          { head: b', tail: _bs } <- uncons as
          a <- a' >>= fromParam >>> hush
          b <- b' >>= fromParam >>> hush
          Just { a, b }
          # case _ of
              Just { a, b } -> next a b req
              Nothing -> pure Nothing
      Nothing -> pure Nothing
    Left error -> reportError error

pathParams3 ::
  forall a b c.
  FromParam a =>
  FromParam b =>
  FromParam c =>
  String -> (a -> b -> c -> Handler) -> Handler
pathParams3 path' next req = do
  case matchPath path' req.path of
    Right maybeMatches -> case maybeMatches of
      Just matches ->
        do
          { head: a', tail: as } <- uncons matches
          { head: b', tail: bs } <- uncons as
          { head: c', tail: _cs } <- uncons bs
          a <- a' >>= fromParam >>> hush
          b <- b' >>= fromParam >>> hush
          c <- c' >>= fromParam >>> hush
          Just { a, b, c }
          # case _ of
              Just { a, b, c } -> next a b c req
              Nothing -> pure Nothing
      Nothing -> pure Nothing
    Left error -> reportError error

header :: forall a. HeaderName -> (HeaderValue -> Maybe a) -> (a -> Handler) -> Handler
header name parseValue next req = do
  case req.headers # Headers.lookup name >>= parseValue of
    Just value -> next value req
    Nothing -> pure Nothing
