module Peregrine.Body
  ( contentLengthLimit
  ) where

import Prelude
import Data.Int as Int
import Data.Maybe (Maybe(..))
import Peregrine (Handler)
import Peregrine.Http.HeaderName as HeaderName
import Peregrine.Http.Headers as Headers
import Peregrine.Response as Response

contentLengthLimit :: Int -> Handler -> Handler
contentLengthLimit limit next req = do
  case req.headers # Headers.lookup HeaderName.contentLength >>= Int.fromString of
    Just length ->
      if length <= limit then
        next req
      else
        pure $ Just $ Response.payloadTooLarge
    Nothing -> pure $ Just $ Response.lengthRequired
