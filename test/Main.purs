module Test.Main where

import Prelude
import Effect (Effect)
import Effect.Aff (launchAff_)
import Peregrine.BodySpec (bodySpec)
import Peregrine.PeregrineSpec (peregrineSpec)
import Test.Peregrine.HttpSpec (httpSpec)
import Test.Peregrine.RoutingSpec (routingSpec)
import Test.Spec (describe)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner (runSpec)

main :: Effect Unit
main = do
  launchAff_ $ runSpec [ consoleReporter ]
    $ describe "Peregrine" do
        bodySpec
        peregrineSpec
        httpSpec
        routingSpec
