module Peregrine where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Node.Encoding (Encoding(..))
import Node.HTTP as Http
import Node.Stream as Stream

type RequestListener
  = Http.Request -> Http.Response -> Effect Unit

mkRequestListener :: RequestListener
mkRequestListener _req res = do
  _ <- Http.setStatusCode res 200
  _ <- Http.setHeader res "Content-Type" "text/plain"
  let
    responseStream = res # Http.responseAsStream
  _ <-
    Stream.writeString responseStream UTF8 "Hello, world!" mempty
  Stream.end responseStream mempty

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
