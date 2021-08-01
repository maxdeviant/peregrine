module Test.Main where

import Prelude
import Effect (Effect)
import Effect.Aff (launchAff_)
import Peregrine.PeregrineSpec (peregrineSpec)
import Test.Peregrine.HttpSpec (httpSpec)
import Test.Spec (describe)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner (runSpec)

main :: Effect Unit
main = do
  launchAff_ $ runSpec [ consoleReporter ]
    $ describe "Peregrine" do
        peregrineSpec
        httpSpec
