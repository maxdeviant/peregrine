module Peregrine.Http.HeaderName
  ( -- Authentication
    wwwAuthenticate
  , authorization
  , proxyAuthenticate
  , proxyAuthorization
  ) where

import Peregrine.Http.Headers (HeaderName, staticHeaderName)
import Type.Proxy (Proxy(..))

{- Authentication -}

-- | `WWW-Authenticate`
-- |
-- | Defines the authentication method that should be used to access a resource.
wwwAuthenticate :: HeaderName
wwwAuthenticate = staticHeaderName (Proxy :: Proxy "WWW-Authenticate")

-- | `Authorization`
-- |
-- | Contains the credentials to authenticate a user-agent with a server.
authorization :: HeaderName
authorization = staticHeaderName (Proxy :: Proxy "Authorization")

-- | `Proxy-Authenticate`
-- |
-- | Defines the authentication method that should be used to access a resource behind a proxy server.
proxyAuthenticate :: HeaderName
proxyAuthenticate = staticHeaderName (Proxy :: Proxy "Proxy-Authenticate")

-- | `Proxy-Authorization`
-- |
-- | Contains the credentials to authenticate a user agent with a proxy server.
proxyAuthorization :: HeaderName
proxyAuthorization = staticHeaderName (Proxy :: Proxy "Proxy-Authorization")
