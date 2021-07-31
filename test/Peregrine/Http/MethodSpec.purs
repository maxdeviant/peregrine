module Test.Peregrine.Http.MethodSpec where

import Prelude
import Data.Maybe (Maybe(..))
import Peregrine.Http.Method (Method(..), fromString)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

methodSpec :: Spec Unit
methodSpec = do
  describe "Method" do
    describe "fromString" do
      let
        test method expected =
          it ("parses \"" <> method <> "\"") do
            fromString method `shouldEqual` Just expected

        testInvalid method =
          it ("returns Nothing when given \"" <> method <> "\"") do
            fromString method `shouldEqual` Nothing
      test "GET" Get
      test "PUT" Put
      test "POST" Post
      test "DELETE" Delete
      test "OPTIONS" Options
      test "HEAD" Head
      test "TRACE" Trace
      test "CONNECT" Connect
      test "PATCH" Patch
      testInvalid ""
      testInvalid " "
      testInvalid "get"
      testInvalid "put"
      testInvalid "post"
      testInvalid "delete"
      testInvalid "options"
      testInvalid "head"
      testInvalid "trace"
      testInvalid "connect"
      testInvalid "patch"
