module Peregrine.Request where

import Peregrine.Http.Method (Method)

-- | An HTTP request.
type Request
  = { method :: Method
    }
