module Peregrine.Http.HeaderName
  ( -- Authentication
    wwwAuthenticate
  , authorization
  , proxyAuthenticate
  , proxyAuthorization
  -- Caching
  , age
  , cacheControl
  , clearSiteData
  , expires
  , pragma
  -- Cookies
  , cookie
  , setCookie
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

{- Caching -}

-- | `Age`
-- |
-- | The time, in seconds, that the object has been in a proxy cache.
age :: HeaderName
age = staticHeaderName (Proxy :: Proxy "Age")

-- | `Cache-Control`
-- |
-- | Directives for caching mechanisms in both requests and responses.
cacheControl :: HeaderName
cacheControl = staticHeaderName (Proxy :: Proxy "Cache-Control")

-- | `Clear-Site-Data`
-- |
-- | Clears browsing data (e.g. cookies, storage, cache) associated with the requesting website.
clearSiteData :: HeaderName
clearSiteData = staticHeaderName (Proxy :: Proxy "Clear-Site-Data")

-- | `Expires`
-- |
-- | The date/time after which the response is considered stale.
expires :: HeaderName
expires = staticHeaderName (Proxy :: Proxy "Expires")

-- | `Pragma`
-- |
-- | Implementation-specific header that may have various effects anywhere along the request-response chain. Used for
-- | backwards compatibility with HTTP/1.0 caches where the `Cache-Control` header is not yet present.
pragma :: HeaderName
pragma = staticHeaderName (Proxy :: Proxy "Pragma")

{- Cookies -}

-- | `Cookie`
-- |
-- | Contains stored HTTP cookies previously sent by the server with the `Set-Cookie` header.
cookie :: HeaderName
cookie = staticHeaderName (Proxy :: Proxy "Cookie")

-- | `Set-Cookie`
-- |
-- | Send cookies from the server to the user-agent.
setCookie :: HeaderName
setCookie = staticHeaderName (Proxy :: Proxy "Set-Cookie")
