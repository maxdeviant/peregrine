module Peregrine.Request.Body where

import Prelude
import Effect.Aff (Aff)

data Body
  = NotParsed (Aff String)
  | Parsed String

empty :: Body
empty = NotParsed $ pure ""