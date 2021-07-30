module Peregrine where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Node.HTTP as Http

type RequestListener
  = Http.Request -> Http.Response -> Effect Unit

mkRequestListener :: RequestListener
mkRequestListener _req _res = pure unit

defaultListenOptions :: Http.ListenOptions
defaultListenOptions =
  { hostname: "0.0.0.0"
  , port: 3000
  , backlog: Nothing
  }

fly :: Effect Unit -> Effect (Effect Unit -> Effect Unit)
fly callback = do
  server <- Http.createServer mkRequestListener
  Http.listen server defaultListenOptions callback
  pure $ Http.close server
