module Peregrine.PeregrineSpec where

import Prelude
import Data.Maybe (Maybe(..), isNothing)
import Peregrine (choose)
import Peregrine.Http.Headers as Headers
import Peregrine.Http.Method (Method(..))
import Peregrine.Http.Status as Status
import Peregrine.Request (Request)
import Peregrine.Response as Response
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
        , body: pure ""
        } ::
          Request
    describe "given an empty list of handlers" do
      it "returns Nothing" do
        result <- choose [] req
        isNothing result `shouldEqual` true
    describe "given a list of handlers" do
      it "returns the first Just response" do
        result <-
          choose
            [ \_req -> pure $ Nothing
            , \_req -> pure $ Just $ Response.ok
            , \_req -> pure $ Just $ Response.unauthorized
            ]
            req
        (result >>= _.status) `shouldEqual` Just Status.ok
