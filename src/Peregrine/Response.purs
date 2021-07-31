module Peregrine.Response where

import Prelude
import Data.Maybe (Maybe)
import Effect.Aff (Aff)
import Node.HTTP as Http
import Peregrine.Headers (Headers)
import Peregrine.Status (Status)

-- | An HTTP response.
type Response
  = { status :: Maybe Status
    , headers :: Headers
    , writeBody :: Maybe (Http.Response -> Aff Unit)
    }
