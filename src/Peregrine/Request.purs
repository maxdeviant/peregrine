module Peregrine.Request where

import Peregrine.Http.Headers (Headers)
import Peregrine.Http.Method (Method)

-- | An HTTP request.
type Request
  = { method :: Method
    , url :: String
    , headers :: Headers
    }
