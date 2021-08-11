module Test.Peregrine.RoutingSpec where

import Prelude
import Data.Maybe (Maybe(..))
import Peregrine.Http.Headers (HeaderName, staticHeaderName)
import Peregrine.Http.Headers as Headers
import Peregrine.Http.Method (Method(..))
import Peregrine.Request (Request)
import Peregrine.Response as Response
import Peregrine.Routing (pathParam, pathParams2)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Type.Proxy (Proxy(..))

routingSpec :: Spec Unit
routingSpec = do
  describe "Routing" do
    describe "pathParam" do
      describe "given a valid path with a single parameter" do
        it "matches" do
          let
            xId :: HeaderName
            xId = staticHeaderName (Proxy :: Proxy "X-ID")

            req =
              { method: Get
              , url: "/123"
              , path: "/123"
              , headers: Headers.empty
              } ::
                Request
          result <-
            req
              # pathParam "/<id>" \id _req ->
                  pure $ Just $ Response.ok # Response.addHeader xId id
          (result # map _.headers >>= Headers.lookup xId) `shouldEqual` Just "123"
    describe "pathParams2" do
      describe "given a valid path with two parameters" do
        it "matches" do
          let
            xFirstName :: HeaderName
            xFirstName = staticHeaderName (Proxy :: Proxy "X-First-Name")

            xLastName :: HeaderName
            xLastName = staticHeaderName (Proxy :: Proxy "X-Last-Name")

            req =
              { method: Get
              , url: "/john/smith"
              , path: "/john/smith"
              , headers: Headers.empty
              } ::
                Request
          result <-
            req
              # pathParams2 "/<firstName>/<lastName>" \firstName lastName _req ->
                  pure $ Just
                    $ Response.ok
                    # Response.addHeader xFirstName firstName
                    # Response.addHeader xLastName lastName
          (result # map _.headers >>= Headers.lookup xFirstName) `shouldEqual` Just "john"
          (result # map _.headers >>= Headers.lookup xLastName) `shouldEqual` Just "smith"
