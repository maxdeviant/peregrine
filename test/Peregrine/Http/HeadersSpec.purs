module Test.Peregrine.Http.HeadersSpec where

import Prelude
import Peregrine.Http.HeaderName as HeaderName
import Peregrine.Http.Headers as Headers
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

headersSpec :: Spec Unit
headersSpec = do
  describe "Headers" do
    describe "show" do
      it "shows a formatted list of headers" do
        let
          headers =
            Headers.empty
              # Headers.insert HeaderName.contentType "application/json"
              # Headers.insert HeaderName.setCookie "sessionId=38afes7a8"
        show headers `shouldEqual` "Content-Type: application/json\nSet-Cookie: sessionId=38afes7a8"
  describe "append (<>)" do
    describe "when a header exists in the first collection but not the second" do
      it "keeps the header value" do
        (Headers.singleton HeaderName.contentType "application/json" <> Headers.empty)
          `shouldEqual`
            Headers.singleton HeaderName.contentType "application/json"
    describe "when a header exists in the second collection but not the first" do
      it "keeps the header value" do
        (Headers.empty <> Headers.singleton HeaderName.contentType "application/json")
          `shouldEqual`
            Headers.singleton HeaderName.contentType "application/json"
    describe "when a header exists in both collections" do
      it "keeps the header value from the second collection" do
        (Headers.singleton HeaderName.contentType "text/html" <> Headers.singleton HeaderName.contentType "application/json")
          `shouldEqual`
            Headers.singleton HeaderName.contentType "application/json"
    describe "when the collections contain disparate headers" do
      it "merges the headers from both collections" do
        (Headers.singleton HeaderName.contentType "application/json" <> Headers.singleton HeaderName.setCookie "sessionId=38afes7a8")
          `shouldEqual`
            ( Headers.empty
                # Headers.insert HeaderName.contentType "application/json"
                # Headers.insert HeaderName.setCookie "sessionId=38afes7a8"
            )
