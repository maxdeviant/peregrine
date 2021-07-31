module Peregrine.Request where

import Peregrine.Method (Method)

-- | An HTTP request.
type Request
  = { method :: Method
    }
