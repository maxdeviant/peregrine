module Peregrine.Response.Body where

import Prelude
import Data.Either (Either(..))
import Effect.Aff (Aff, makeAff, nonCanceler)
import Effect.Class (liftEffect)
import Node.Buffer (Buffer)
import Node.Buffer as Buffer
import Node.Encoding (Encoding(..))
import Node.HTTP as Http
import Node.Stream as Stream

class Body b where
  write :: b -> Http.Response -> Aff Unit

instance bodyString :: Body String where
  write body res = do
    buffer :: Buffer <- liftEffect $ Buffer.fromString body UTF8
    res # write buffer

instance bodyBuffer :: Body Buffer where
  write body res =
    makeAff \callback -> do
      let
        stream = Http.responseAsStream res
      _ <- Stream.write stream body $ Stream.end stream $ callback $ Right unit
      pure nonCanceler
