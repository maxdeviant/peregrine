module Peregrine where

import Prelude
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Newtype (unwrap, wrap)
import Data.String.NonEmpty (nes)
import Data.String.NonEmpty as NonEmptyString
import Data.String.NonEmpty.CaseInsensitive (CaseInsensitiveNonEmptyString)
import Data.TraversableWithIndex (traverseWithIndex)
import Effect (Effect)
import Node.Encoding (Encoding(..))
import Node.HTTP as Http
import Node.Stream as Stream
import Peregrine.Headers (Headers(..))
import Peregrine.Headers as Headers
import Peregrine.Response (Response)
import Peregrine.Status (Status)
import Peregrine.Status as Status
import Type.Proxy (Proxy(..))

contentType :: CaseInsensitiveNonEmptyString
contentType = wrap $ nes (Proxy :: Proxy "Content-Type")

type RequestListener
  = Http.Request -> Http.Response -> Effect Unit

writeStatus :: Http.Response -> Status -> Effect Unit
writeStatus res { code, reason } = do
  _ <- Http.setStatusCode res code
  _ <- Http.setStatusMessage res reason
  pure unit

writeHeaders :: Http.Response -> Headers -> Effect Unit
writeHeaders res (Headers headers) =
  void
    $ traverseWithIndex setHeader headers
  where
  setHeader key value = Http.setHeader res (NonEmptyString.toString $ unwrap key) value

writeResponse :: Http.Response -> Response -> Effect Unit
writeResponse res response = do
  let
    status = response.status # fromMaybe Status.ok
  _ <- writeStatus res status
  _ <- writeHeaders res response.headers
  pure unit

mkRequestListener :: RequestListener
mkRequestListener _req res = do
  let
    response =
      { status: Just Status.ok
      , headers: Headers.empty # Headers.insert contentType "text/plain"
      , body: Nothing
      }
  _ <- writeResponse res response
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
