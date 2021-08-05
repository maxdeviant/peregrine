module Test.Peregrine.RoutingSpec where

import Prelude
import Data.Map as Map
import Data.Maybe (Maybe(..))
import Peregrine.Http.Headers (HeaderName, staticHeaderName)
import Peregrine.Http.Headers as Headers
import Peregrine.Http.Method (Method(..))
import Peregrine.Request (Request)
import Peregrine.Response as Response
import Peregrine.Routing (pathParams)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Type.Proxy (Proxy(..))

routingSpec :: Spec Unit
routingSpec = do
  describe "Routing" do
    describe "pathParams" do
      describe "given a valid path with a single parameter" do
        it "matches" do
          let
            xId :: HeaderName
            xId = staticHeaderName (Proxy :: Proxy "X-ID")

            parseParams params = do
              id <- params # Map.lookup "id"
              Just { id }

            req =
              { method: Get
              , url: "/123"
              , path: "/123"
              , headers: Headers.empty
              } ::
                Request
          result <-
            req
              # pathParams "/<id>" parseParams \{ id } _req ->
                  pure $ Just $ Response.ok # Response.addHeader xId id
          (result # map _.headers >>= Headers.lookup xId) `shouldEqual` Just "123"
      describe "given a valid path with two parameters" do
        it "matches" do
          let
            xFirstName :: HeaderName
            xFirstName = staticHeaderName (Proxy :: Proxy "X-First-Name")

            xLastName :: HeaderName
            xLastName = staticHeaderName (Proxy :: Proxy "X-Last-Name")

            parseParams params = do
              firstName <- params # Map.lookup "firstName"
              lastName <- params # Map.lookup "lastName"
              Just { firstName, lastName }

            req =
              { method: Get
              , url: "/john/smith"
              , path: "/john/smith"
              , headers: Headers.empty
              } ::
                Request
          result <-
            req
              # pathParams "/<firstName>/<lastName>" parseParams \{ firstName, lastName } _req ->
                  pure $ Just
                    $ Response.ok
                    # Response.addHeader xFirstName firstName
                    # Response.addHeader xLastName lastName
          (result # map _.headers >>= Headers.lookup xFirstName) `shouldEqual` Just "john"
          (result # map _.headers >>= Headers.lookup xLastName) `shouldEqual` Just "smith"
