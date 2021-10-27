module Peregrine.Request where

import Effect.Aff (Aff)
import Peregrine.Http.Headers (Headers)
import Peregrine.Http.Method (Method)

-- | An HTTP request.
type Request
  =
  { method :: Method
  , url :: String
  , path :: String
  , headers :: Headers
  , body :: Aff String
  }
