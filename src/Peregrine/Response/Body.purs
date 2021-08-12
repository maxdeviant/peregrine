module Peregrine.Response.Body where

import Prelude
import Node.Buffer.Immutable (ImmutableBuffer)
import Node.Buffer.Immutable as ImmutableBuffer
import Node.Encoding (Encoding(..))
import Safe.Coerce (coerce)

-- | An HTTP response body.
newtype Body
  = Body ImmutableBuffer

size :: Body -> Int
size = coerce >>> ImmutableBuffer.size

text :: String -> Body
text = flip ImmutableBuffer.fromString UTF8 >>> Body
