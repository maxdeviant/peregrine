module Test.Peregrine.HttpSpec where

import Prelude
import Test.Peregrine.Http.HeadersSpec (headersSpec)
import Test.Peregrine.Http.MethodSpec (methodSpec)
import Test.Spec (Spec, describe)

httpSpec :: Spec Unit
httpSpec = do
  describe "Http" do
    headersSpec
    methodSpec
