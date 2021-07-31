module Test.Peregrine.Http.HeadersSpec where

import Prelude
import Peregrine.Http.Headers (staticHeaderName)
import Peregrine.Http.Headers as Headers
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Type.Proxy (Proxy(..))

headersSpec :: Spec Unit
headersSpec = do
  describe "Headers" do
    describe "show" do
      it "shows a formatted list of headers" do
        let
          contentType = staticHeaderName (Proxy :: Proxy "Content-Type")

          setCookie = staticHeaderName (Proxy :: Proxy "Set-Cookie")

          headers =
            Headers.empty
              # Headers.insert contentType "application/json"
              # Headers.insert setCookie "sessionId=38afes7a8"
        show headers `shouldEqual` "Content-Type: application/json\nSet-Cookie: sessionId=38afes7a8"
