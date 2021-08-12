module Peregrine.Response.Body where

import Prelude
import Data.Newtype (class Newtype)
import Node.Buffer.Immutable (ImmutableBuffer)
import Node.Buffer.Immutable as ImmutableBuffer
import Node.Encoding (Encoding(..))
import Safe.Coerce (coerce)

-- | An HTTP response body.
newtype Body
  = Body ImmutableBuffer

derive instance newtypeBody :: Newtype Body _

derive newtype instance showBody :: Show Body

derive newtype instance eqBody :: Eq Body

size :: Body -> Int
size = coerce >>> ImmutableBuffer.size

text :: String -> Body
text = flip ImmutableBuffer.fromString UTF8 >>> Body

toString :: Body -> String
toString = coerce >>> ImmutableBuffer.toString UTF8
