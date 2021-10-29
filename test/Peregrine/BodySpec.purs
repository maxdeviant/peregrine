module Peregrine.BodySpec where

import Prelude
import Data.Maybe (Maybe(..))
import Peregrine.Body (contentLengthLimit)
import Peregrine.Http.HeaderName as HeaderName
import Peregrine.Http.Headers as Headers
import Peregrine.Http.Method (Method(..))
import Peregrine.Http.Status as Status
import Peregrine.Request (Request)
import Peregrine.Request.Body as Request.Body
import Peregrine.Response as Response
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

bodySpec :: Spec Unit
bodySpec = do
  describe "contentLengthLimit" do
    let
      baseReq =
        { method: Post
        , url: "/"
        , path: "/"
        , headers: Headers.empty
        , body: Request.Body.empty
        } ::
          Request

      success = \_req -> pure $ Just $ Response.ok

    describe "when the request has a valid `Content-Length` header" do
      describe "that is less than the specified limit" do
        it "accepts the request" do
          let req = baseReq { headers = Headers.singleton HeaderName.contentLength "1023" }

          result <- req # contentLengthLimit 1024 success
          (result >>= _.status) `shouldEqual` Just Status.ok

      describe "that is equal to the specified limit" do
        it "accepts the request" do
          let req = baseReq { headers = Headers.singleton HeaderName.contentLength "1024" }

          result <- req # contentLengthLimit 1024 success
          (result >>= _.status) `shouldEqual` Just Status.ok

      describe "that is greater than the specified limit" do
        it "returns 413 Payload Too Large" do
          let req = baseReq { headers = Headers.singleton HeaderName.contentLength "1025" }

          result <- req # contentLengthLimit 1024 success
          (result >>= _.status) `shouldEqual` Just Status.payloadTooLarge

    describe "when the request has an invalid `Content-Length` header" do
      it "returns 411 Length Required" do
        let req = baseReq

        result <- req # contentLengthLimit 1024 success
        (result >>= _.status) `shouldEqual` Just Status.lengthRequired

    describe "when the request is missing the `Content-Length` header" do
      it "returns 411 Length Required" do
        let req = baseReq

        result <- req # contentLengthLimit 1024 success
        (result >>= _.status) `shouldEqual` Just Status.lengthRequired
