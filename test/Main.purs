module Test.Main where

import Prelude
import Effect (Effect)
import Effect.Class.Console (log)
import Peregrine as Peregrine

main :: Effect (Effect Unit -> Effect Unit)
main =
  Peregrine.fly do
    log "Hello World"
