module Peregrine.Response
  ( Response
  , fromStatus
  , withHeaders
  , addHeader
  , addHeaders
  , withBody
  -- 1xx: Information responses
  , continue
  , switchingProtocols
  , processing
  -- 2xx: Successful responses
  , ok
  , created
  , accepted
  , nonAuthoritativeInformation
  , noContent
  , resetContent
  , partialContent
  , multiStatus
  , alreadyReported
  , imUsed
  -- 3xx: Redirection messages
  , multipleChoices
  , movedPermanently
  , found
  , seeOther
  , notModified
  , useProxy
  , temporaryRedirect
  , permanentRedirect
  -- 4xx: Client error responses
  , badRequest
  , unauthorized
  , paymentRequired
  , forbidden
  , notFound
  , methodNotAllowed
  , notAcceptable
  , proxyAuthenticationRequired
  , requestTimeout
  , conflict
  , gone
  , lengthRequired
  , preconditionFailed
  , payloadTooLarge
  , uriTooLong
  , unsupportedMediaType
  , rangeNotSatisfiable
  , expectationFailed
  , imATeapot
  , misdirectedRequest
  , unprocessableEntity
  , locked
  , failedDependency
  , upgradeRequired
  , preconditionRequired
  , tooManyRequests
  , requestHeaderFieldsTooLarge
  , unavailableForLegalReasons
  -- 5xx: Server error responses
  , internalServerError
  , notImplemented
  , badGateway
  , serviceUnavailable
  , gatewayTimeout
  , httpVersionNotSupported
  , variantAlsoNegotiates
  , insufficientStorage
  , loopDetected
  , notExtended
  , networkAuthenticationRequired
  ) where

import Prelude
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Node.HTTP as Http
import Peregrine.Http.Headers (HeaderName, Headers, HeaderValue)
import Peregrine.Http.Headers as Headers
import Peregrine.Http.Status (Status)
import Peregrine.Http.Status as Status
import Peregrine.Response.Body (class Body)
import Peregrine.Response.Body as Body

-- | An HTTP response.
type Response
  = { status :: Maybe Status
    , headers :: Headers
    , writeBody :: Maybe (Http.Response -> Aff Unit)
    }

fromStatus :: Status -> Response
fromStatus status =
  { status: Just status
  , headers: Headers.empty
  , writeBody: Just $ Body.write status.reason
  }

-- | Sets the response headers, overwriting any existing headers.
withHeaders :: Headers -> Response -> Response
withHeaders headers res = res { headers = headers }

-- | Adds a header to the response.
-- |
-- | If the response already contains a header with the specified name it will
-- | be overwritten.
addHeader :: HeaderName -> HeaderValue -> Response -> Response
addHeader name value res = res { headers = res.headers # Headers.insert name value }

addHeaders :: Headers -> Response -> Response
addHeaders headers res = res { headers = res.headers <> headers }

withBody :: forall b. Body b => b -> Response -> Response
withBody body res = res { writeBody = Just $ Body.write body }

-- | Returns a `100 Continue` response with the reason phrase in the body.
continue :: Response
continue = fromStatus Status.continue

-- | Returns a `101 Switching Protocols` response with the reason phrase in the body.
switchingProtocols :: Response
switchingProtocols = fromStatus Status.switchingProtocols

-- | Returns a `102 Processing` response with the reason phrase in the body.
processing :: Response
processing = fromStatus Status.processing

-- | Returns a `200 OK` response with the reason phrase in the body.
ok :: Response
ok = fromStatus Status.ok

-- | Returns a `201 Created` response with the reason phrase in the body.
created :: Response
created = fromStatus Status.created

-- | Returns a `202 Accepted` response with the reason phrase in the body.
accepted :: Response
accepted = fromStatus Status.accepted

-- | Returns a `203 Non-Authoritative Information` response with the reason phrase in the body.
nonAuthoritativeInformation :: Response
nonAuthoritativeInformation = fromStatus Status.nonAuthoritativeInformation

-- | Returns a `204 No Content` response with the reason phrase in the body.
noContent :: Response
noContent = fromStatus Status.noContent

-- | Returns a `205 Reset Content` response with the reason phrase in the body.
resetContent :: Response
resetContent = fromStatus Status.resetContent

-- | Returns a `206 Partial Content` response with the reason phrase in the body.
partialContent :: Response
partialContent = fromStatus Status.partialContent

-- | Returns a `207 Multi-Status` response with the reason phrase in the body.
multiStatus :: Response
multiStatus = fromStatus Status.multiStatus

-- | Returns a `208 Already Reported` response with the reason phrase in the body.
alreadyReported :: Response
alreadyReported = fromStatus Status.alreadyReported

-- | Returns a `226 IM Used` response with the reason phrase in the body.
imUsed :: Response
imUsed = fromStatus Status.imUsed

-- | Returns a `300 Multiple Choices` response with the reason phrase in the body.
multipleChoices :: Response
multipleChoices = fromStatus Status.multipleChoices

-- | Returns a `301 Moved Permanently` response with the reason phrase in the body.
movedPermanently :: Response
movedPermanently = fromStatus Status.movedPermanently

-- | Returns a `302 Found` response with the reason phrase in the body.
found :: Response
found = fromStatus Status.found

-- | Returns a `303 See Other` response with the reason phrase in the body.
seeOther :: Response
seeOther = fromStatus Status.seeOther

-- | Returns a `304 Not Modified` response with the reason phrase in the body.
notModified :: Response
notModified = fromStatus Status.notModified

-- | Returns a `305 Use Proxy` response with the reason phrase in the body.
useProxy :: Response
useProxy = fromStatus Status.useProxy

-- | Returns a `307 Temporary Redirect` response with the reason phrase in the body.
temporaryRedirect :: Response
temporaryRedirect = fromStatus Status.temporaryRedirect

-- | Returns a `308 Permanent Redirect` response with the reason phrase in the body.
permanentRedirect :: Response
permanentRedirect = fromStatus Status.permanentRedirect

-- | Returns a `400 Bad Request` response with the reason phrase in the body.
badRequest :: Response
badRequest = fromStatus Status.badRequest

-- | Returns a `401 Unauthorized` response with the reason phrase in the body.
unauthorized :: Response
unauthorized = fromStatus Status.unauthorized

-- | Returns a `402 Payment Required` response with the reason phrase in the body.
paymentRequired :: Response
paymentRequired = fromStatus Status.paymentRequired

-- | Returns a `403 Forbidden` response with the reason phrase in the body.
forbidden :: Response
forbidden = fromStatus Status.forbidden

-- | Returns a `404 Not Found` response with the reason phrase in the body.
notFound :: Response
notFound = fromStatus Status.notFound

-- | Returns a `405 Method Not Allowed` response with the reason phrase in the body.
methodNotAllowed :: Response
methodNotAllowed = fromStatus Status.methodNotAllowed

-- | Returns a `406 Not Acceptable` response with the reason phrase in the body.
notAcceptable :: Response
notAcceptable = fromStatus Status.notAcceptable

-- | Returns a `407 Proxy Authentication Required` response with the reason phrase in the body.
proxyAuthenticationRequired :: Response
proxyAuthenticationRequired = fromStatus Status.proxyAuthenticationRequired

-- | Returns a `408 Request Timeout` response with the reason phrase in the body.
requestTimeout :: Response
requestTimeout = fromStatus Status.requestTimeout

-- | Returns a `409 Conflict` response with the reason phrase in the body.
conflict :: Response
conflict = fromStatus Status.conflict

-- | Returns a `410 Gone` response with the reason phrase in the body.
gone :: Response
gone = fromStatus Status.gone

-- | Returns a `411 Length Required` response with the reason phrase in the body.
lengthRequired :: Response
lengthRequired = fromStatus Status.lengthRequired

-- | Returns a `412 Precondition Failed` response with the reason phrase in the body.
preconditionFailed :: Response
preconditionFailed = fromStatus Status.preconditionFailed

-- | Returns a `413 Payload Too Large` response with the reason phrase in the body.
payloadTooLarge :: Response
payloadTooLarge = fromStatus Status.payloadTooLarge

-- | Returns a `414 URI Too Long` response with the reason phrase in the body.
uriTooLong :: Response
uriTooLong = fromStatus Status.uriTooLong

-- | Returns a `415 Unsupported Media Type` response with the reason phrase in the body.
unsupportedMediaType :: Response
unsupportedMediaType = fromStatus Status.unsupportedMediaType

-- | Returns a `416 Range Not Satisfiable` response with the reason phrase in the body.
rangeNotSatisfiable :: Response
rangeNotSatisfiable = fromStatus Status.rangeNotSatisfiable

-- | Returns a `417 Expectation Failed` response with the reason phrase in the body.
expectationFailed :: Response
expectationFailed = fromStatus Status.expectationFailed

-- | Returns a `418 I'm a teapot` response with the reason phrase in the body.
imATeapot :: Response
imATeapot = fromStatus Status.imATeapot

-- | Returns a `421 Misdirected Request` response with the reason phrase in the body.
misdirectedRequest :: Response
misdirectedRequest = fromStatus Status.misdirectedRequest

-- | Returns a `422 Unprocessable Entity` response with the reason phrase in the body.
unprocessableEntity :: Response
unprocessableEntity = fromStatus Status.unprocessableEntity

-- | Returns a `423 Locked` response with the reason phrase in the body.
locked :: Response
locked = fromStatus Status.locked

-- | Returns a `424 Failed Dependency` response with the reason phrase in the body.
failedDependency :: Response
failedDependency = fromStatus Status.failedDependency

-- | Returns a `426 Upgrade Required` response with the reason phrase in the body.
upgradeRequired :: Response
upgradeRequired = fromStatus Status.upgradeRequired

-- | Returns a `428 Precondition Required` response with the reason phrase in the body.
preconditionRequired :: Response
preconditionRequired = fromStatus Status.preconditionRequired

-- | Returns a `429 Too Many Requests` response with the reason phrase in the body.
tooManyRequests :: Response
tooManyRequests = fromStatus Status.tooManyRequests

-- | Returns a `431 Request Header Fields Too Large` response with the reason phrase in the body.
requestHeaderFieldsTooLarge :: Response
requestHeaderFieldsTooLarge = fromStatus Status.requestHeaderFieldsTooLarge

-- | Returns a `451 Unavailable For Legal Reasons` response with the reason phrase in the body.
unavailableForLegalReasons :: Response
unavailableForLegalReasons = fromStatus Status.unavailableForLegalReasons

-- | Returns a `500 Internal Server Error` response with the reason phrase in the body.
internalServerError :: Response
internalServerError = fromStatus Status.internalServerError

-- | Returns a `501 Not Implemented` response with the reason phrase in the body.
notImplemented :: Response
notImplemented = fromStatus Status.notImplemented

-- | Returns a `502 Bad Gateway` response with the reason phrase in the body.
badGateway :: Response
badGateway = fromStatus Status.badGateway

-- | Returns a `503 Service Unavailable` response with the reason phrase in the body.
serviceUnavailable :: Response
serviceUnavailable = fromStatus Status.serviceUnavailable

-- | Returns a `504 Gateway Timeout` response with the reason phrase in the body.
gatewayTimeout :: Response
gatewayTimeout = fromStatus Status.gatewayTimeout

-- | Returns a `505 HTTP Version Not Supported` response with the reason phrase in the body.
httpVersionNotSupported :: Response
httpVersionNotSupported = fromStatus Status.httpVersionNotSupported

-- | Returns a `506 Variant Also Negotiates` response with the reason phrase in the body.
variantAlsoNegotiates :: Response
variantAlsoNegotiates = fromStatus Status.variantAlsoNegotiates

-- | Returns a `507 Insufficient Storage` response with the reason phrase in the body.
insufficientStorage :: Response
insufficientStorage = fromStatus Status.insufficientStorage

-- | Returns a `508 Loop Detected` response with the reason phrase in the body.
loopDetected :: Response
loopDetected = fromStatus Status.loopDetected

-- | Returns a `510 Not Extended` response with the reason phrase in the body.
notExtended :: Response
notExtended = fromStatus Status.notExtended

-- | Returns a `511 Network Authentication Required` response with the reason phrase in the body.
networkAuthenticationRequired :: Response
networkAuthenticationRequired = fromStatus Status.networkAuthenticationRequired
