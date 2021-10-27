module Peregrine.Http.Status
  ( Status
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

-- | An HTTP status.
type Status
  =
  { code :: Int
  , reason :: String
  }

mkStatus :: Int -> String -> Status
mkStatus code reason = { code, reason }

-- | `100 Continue`
continue :: Status
continue = mkStatus 100 "Continue"

-- | `101 Switching Protocols`
switchingProtocols :: Status
switchingProtocols = mkStatus 101 "Switching Protocols"

-- | `102 Processing`
processing :: Status
processing = mkStatus 102 "Processing"

-- | `200 OK`
ok :: Status
ok = mkStatus 200 "OK"

-- | `201 Created`
created :: Status
created = mkStatus 201 "Created"

-- | `202 Accepted`
accepted :: Status
accepted = mkStatus 202 "Accepted"

-- | `203 Non-Authoritative Information`
nonAuthoritativeInformation :: Status
nonAuthoritativeInformation = mkStatus 203 "Non-Authoritative Information"

-- | `204 No Content`
noContent :: Status
noContent = mkStatus 204 "No Content"

-- | `205 Reset Content`
resetContent :: Status
resetContent = mkStatus 205 "Reset Content"

-- | `206 Partial Content`
partialContent :: Status
partialContent = mkStatus 206 "Partial Content"

-- | `207 Multi-Status`
multiStatus :: Status
multiStatus = mkStatus 207 "Multi-Status"

-- | `208 Already Reported`
alreadyReported :: Status
alreadyReported = mkStatus 208 "Already Reported"

-- | `226 IM Used`
imUsed :: Status
imUsed = mkStatus 226 "IM Used"

-- | `300 Multiple Choices`
multipleChoices :: Status
multipleChoices = mkStatus 300 "Multiple Choices"

-- | `301 Moved Permanently`
movedPermanently :: Status
movedPermanently = mkStatus 301 "Moved Permanently"

-- | `302 Found`
found :: Status
found = mkStatus 302 "Found"

-- | `303 See Other`
seeOther :: Status
seeOther = mkStatus 303 "See Other"

-- | `304 Not Modified`
notModified :: Status
notModified = mkStatus 304 "Not Modified"

-- | `305 Use Proxy`
useProxy :: Status
useProxy = mkStatus 305 "Use Proxy"

-- | `307 Temporary Redirect`
temporaryRedirect :: Status
temporaryRedirect = mkStatus 307 "Temporary Redirect"

-- | `308 Permanent Redirect`
permanentRedirect :: Status
permanentRedirect = mkStatus 308 "Permanent Redirect"

-- | `400 Bad Request`
badRequest :: Status
badRequest = mkStatus 400 "Bad Request"

-- | `401 Unauthorized`
unauthorized :: Status
unauthorized = mkStatus 401 "Unauthorized"

-- | `402 Payment Required`
paymentRequired :: Status
paymentRequired = mkStatus 402 "Payment Required"

-- | `403 Forbidden`
forbidden :: Status
forbidden = mkStatus 403 "Forbidden"

-- | `404 Not Found`
notFound :: Status
notFound = mkStatus 404 "Not Found"

-- | `405 Method Not Allowed`
methodNotAllowed :: Status
methodNotAllowed = mkStatus 405 "Method Not Allowed"

-- | `406 Not Acceptable`
notAcceptable :: Status
notAcceptable = mkStatus 406 "Not Acceptable"

-- | `407 Proxy Authentication Required`
proxyAuthenticationRequired :: Status
proxyAuthenticationRequired = mkStatus 407 "Proxy Authentication Required"

-- | `408 Request Timeout`
requestTimeout :: Status
requestTimeout = mkStatus 408 "Request Timeout"

-- | `409 Conflict`
conflict :: Status
conflict = mkStatus 409 "Conflict"

-- | `410 Gone`
gone :: Status
gone = mkStatus 410 "Gone"

-- | `411 Length Required`
lengthRequired :: Status
lengthRequired = mkStatus 411 "Length Required"

-- | `412 Precondition Failed`
preconditionFailed :: Status
preconditionFailed = mkStatus 412 "Precondition Failed"

-- | `413 Payload Too Large`
payloadTooLarge :: Status
payloadTooLarge = mkStatus 413 "Payload Too Large"

-- | `414 URI Too Long`
uriTooLong :: Status
uriTooLong = mkStatus 414 "URI Too Long"

-- | `415 Unsupported Media Type`
unsupportedMediaType :: Status
unsupportedMediaType = mkStatus 415 "Unsupported Media Type"

-- | `416 Range Not Satisfiable`
rangeNotSatisfiable :: Status
rangeNotSatisfiable = mkStatus 416 "Range Not Satisfiable"

-- | `417 Expectation Failed`
expectationFailed :: Status
expectationFailed = mkStatus 417 "Expectation Failed"

-- | `418 I'm a teapot`
imATeapot :: Status
imATeapot = mkStatus 418 "I'm a teapot"

-- | `421 Misdirected Request`
misdirectedRequest :: Status
misdirectedRequest = mkStatus 421 "Misdirected Request"

-- | `422 Unprocessable Entity`
unprocessableEntity :: Status
unprocessableEntity = mkStatus 422 "Unprocessable Entity"

-- | `423 Locked`
locked :: Status
locked = mkStatus 423 "Locked"

-- | `424 Failed Dependency`
failedDependency :: Status
failedDependency = mkStatus 424 "Failed Dependency"

-- | `426 Upgrade Required`
upgradeRequired :: Status
upgradeRequired = mkStatus 426 "Upgrade Required"

-- | `428 Precondition Required`
preconditionRequired :: Status
preconditionRequired = mkStatus 428 "Precondition Required"

-- | `429 Too Many Requests`
tooManyRequests :: Status
tooManyRequests = mkStatus 429 "Too Many Requests"

-- | `431 Request Header Fields Too Large`
requestHeaderFieldsTooLarge :: Status
requestHeaderFieldsTooLarge = mkStatus 431 "Request Header Fields Too Large"

-- | `451 Unavailable For Legal Reasons`
unavailableForLegalReasons :: Status
unavailableForLegalReasons = mkStatus 451 "Unavailable For Legal Reasons"

-- | `500 Internal Server Error`
internalServerError :: Status
internalServerError = mkStatus 500 "Internal Server Error"

-- | `501 Not Implemented`
notImplemented :: Status
notImplemented = mkStatus 501 "Not Implemented"

-- | `502 Bad Gateway`
badGateway :: Status
badGateway = mkStatus 502 "Bad Gateway"

-- | `503 Service Unavailable`
serviceUnavailable :: Status
serviceUnavailable = mkStatus 503 "Service Unavailable"

-- | `504 Gateway Timeout`
gatewayTimeout :: Status
gatewayTimeout = mkStatus 504 "Gateway Timeout"

-- | `505 HTTP Version Not Supported`
httpVersionNotSupported :: Status
httpVersionNotSupported = mkStatus 505 "HTTP Version Not Supported"

-- | `506 Variant Also Negotiates`
variantAlsoNegotiates :: Status
variantAlsoNegotiates = mkStatus 506 "Variant Also Negotiates"

-- | `507 Insufficient Storage`
insufficientStorage :: Status
insufficientStorage = mkStatus 507 "Insufficient Storage"

-- | `508 Loop Detected`
loopDetected :: Status
loopDetected = mkStatus 508 "Loop Detected"

-- | `510 Not Extended`
notExtended :: Status
notExtended = mkStatus 510 "Not Extended"

-- | `511 Network Authentication Required`
networkAuthenticationRequired :: Status
networkAuthenticationRequired = mkStatus 511 "Network Authentication Required"
