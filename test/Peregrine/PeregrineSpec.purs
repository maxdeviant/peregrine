module Peregrine.PeregrineSpec where

import Prelude
import Data.Maybe (Maybe(..), isNothing)
import Peregrine (choose)
import Peregrine.Http.Headers as Headers
import Peregrine.Http.Method (Method(..))
import Peregrine.Http.Status as Status
import Peregrine.Request (Request)
import Peregrine.Response (Response)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

peregrineSpec :: Spec Unit
peregrineSpec = do
  describe "choose" do
    let
      req =
        { method: Get
        , url: "/"
        , path: "/"
        , headers: Headers.empty
        } ::
          Request
    describe "given an empty list of handlers" do
      it "returns Nothing" do
        result <- choose [] req
        isNothing result `shouldEqual` true
    describe "given a list of handlers" do
      it "returns the first Just response" do
        let
          emptyResponse =
            { status: Nothing
            , headers: Headers.empty
            , writeBody: Nothing
            } ::
              Response
        result <-
          choose
            [ \_req -> pure $ Nothing
            , \_req -> pure $ Just emptyResponse { status = Just Status.ok }
            , \_req -> pure $ Just emptyResponse { status = Just Status.unauthorized }
            ]
            req
        (result >>= _.status) `shouldEqual` Just Status.ok
