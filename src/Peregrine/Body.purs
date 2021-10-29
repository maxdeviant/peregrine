module Peregrine.Body
  ( contentLengthLimit
  ) where

import Prelude
import Data.Int as Int
import Data.Maybe (Maybe(..))
import Peregrine (Handler)
import Peregrine.Http.Headers (HeaderName, staticHeaderName)
import Peregrine.Http.Headers as Headers
import Peregrine.Response as Response
import Type.Proxy (Proxy(..))

contentLength :: HeaderName
contentLength = staticHeaderName (Proxy :: Proxy "Content-Length")

contentLengthLimit :: Int -> Handler -> Handler
contentLengthLimit limit next req = do
  case req.headers # Headers.lookup contentLength >>= Int.fromString of
    Just length ->
      if length <= limit then
        next req
      else
        pure $ Just $ Response.payloadTooLarge
    Nothing -> pure $ Just $ Response.lengthRequired
