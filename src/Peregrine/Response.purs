module Peregrine.Response where

import Data.Maybe (Maybe)
import Peregrine.Headers (Headers)
import Peregrine.Status (Status)

-- | An HTTP response.
type Response
  = { status :: Maybe Status
    , headers :: Headers
    , body :: Maybe String
    }
