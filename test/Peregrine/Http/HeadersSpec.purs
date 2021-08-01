module Test.Peregrine.Http.HeadersSpec where

import Prelude
import Peregrine.Http.Headers (HeaderName, staticHeaderName)
import Peregrine.Http.Headers as Headers
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Type.Proxy (Proxy(..))

contentType :: HeaderName
contentType = staticHeaderName (Proxy :: Proxy "Content-Type")

setCookie :: HeaderName
setCookie = staticHeaderName (Proxy :: Proxy "Set-Cookie")

headersSpec :: Spec Unit
headersSpec = do
  describe "Headers" do
    describe "show" do
      it "shows a formatted list of headers" do
        let
          headers =
            Headers.empty
              # Headers.insert contentType "application/json"
              # Headers.insert setCookie "sessionId=38afes7a8"
        show headers `shouldEqual` "Content-Type: application/json\nSet-Cookie: sessionId=38afes7a8"
  describe "append (<>)" do
    describe "when a header exists in the first collection but not the second" do
      it "keeps the header value" do
        (Headers.singleton contentType "application/json" <> Headers.empty)
          `shouldEqual`
            Headers.singleton contentType "application/json"
    describe "when a header exists in the second collection but not the first" do
      it "keeps the header value" do
        (Headers.empty <> Headers.singleton contentType "application/json")
          `shouldEqual`
            Headers.singleton contentType "application/json"
    describe "when a header exists in both collections" do
      it "keeps the header value from the second collection" do
        (Headers.singleton contentType "text/html" <> Headers.singleton contentType "application/json")
          `shouldEqual`
            Headers.singleton contentType "application/json"
    describe "when the collections contain disparate headers" do
      it "merges the headers from both collections" do
        (Headers.singleton contentType "application/json" <> Headers.singleton setCookie "sessionId=38afes7a8")
          `shouldEqual`
            ( Headers.empty
                # Headers.insert contentType "application/json"
                # Headers.insert setCookie "sessionId=38afes7a8"
            )
