module Peregrine.Request where

import Peregrine.Http.Headers (Headers)
import Peregrine.Http.Method (Method)
import Peregrine.Request.Body (Body)

-- | An HTTP request.
type Request
  =
  { method :: Method
  , url :: String
  , path :: String
  , headers :: Headers
  , body :: Body
  }
