module Peregrine.Request where

import Prelude

import Effect.Aff (Aff)
import Peregrine.Http.Headers (Headers)
import Peregrine.Http.Method (Method)
import Peregrine.Request.Body (Body(..))

-- | An HTTP request.
type Request
  =
  { method :: Method
  , url :: String
  , path :: String
  , headers :: Headers
  , body :: Body
  }

parseBody :: Request -> Aff { body :: String, req' :: Request }
parseBody req = do
  body <- case req.body of
    NotParsed body -> body
    Parsed body -> pure body
  pure { body, req': req { body = Parsed body } }
