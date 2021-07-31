module Test.Main where

import Prelude
import Data.Maybe (Maybe(..))
import Data.Newtype (wrap)
import Data.String.NonEmpty (nes)
import Data.String.NonEmpty.CaseInsensitive (CaseInsensitiveNonEmptyString)
import Effect (Effect)
import Effect.Class.Console (log)
import Peregrine (Handler)
import Peregrine as Peregrine
import Peregrine.Headers as Headers
import Peregrine.Response.Body as Body
import Peregrine.Status as Status
import Type.Proxy (Proxy(..))

contentType :: CaseInsensitiveNonEmptyString
contentType = wrap $ nes (Proxy :: Proxy "Content-Type")

helloWorld :: Handler
helloWorld _req = do
  pure
    $ { status: Just Status.ok
      , headers: Headers.empty # Headers.insert contentType "text/plain"
      , writeBody: Just $ Body.write "Hello, world!"
      }

main :: Effect (Effect Unit -> Effect Unit)
main =
  Peregrine.fly helloWorld do
    log "Peregrine server listing at http://localhost:3000"
