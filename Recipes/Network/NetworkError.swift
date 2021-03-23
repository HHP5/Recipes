//
//  File.swift
//  Recipes
//
//  Created by Екатерина Григорьева on 22.03.2021.
//

import Foundation

enum NetworkError: String, Error {
    
    case none
    
    case clientError = "An SSL error has occurred and a secure connection to the server cannot be made."
    case noData = "Response returned with no data to decode"
    case dataDecodingError = "Error decoding response"
    
    case multipleChoices = "multipleChoices: Indicates multiple options for the resource from which the client may choose"
    case movedPermanently = "movedPermanently: This and all future requests should be directed to the given URI."
    case found = "found: The resource was found."
    case seeOther = "seeOther: The response to the request can be found under another URI using a GET method"
    case notModified = "notModified: Indicates that the resource has not been modified since the version specified by the request headers If-Modified-Since or If-None-Match."
    case useProxy = "useProxy: The requested resource is available only through a proxy, the address for which is provided in the response."
    case switchProxy = "switchProxy: No longer used. Originally meant: Subsequent requests should use the specified proxy."
    case temporaryRedirecte = "temporaryRedirect: The request should be repeated with another URI."
    case permenantRedirect = "permenantRedirect: The request and all future requests should be repeated using another URI."

    // Client Error - 4xx

    case badRequest = "badRequest: The server cannot or will not process the request due to an apparent client error."
    case unauthorized = "unauthorized: Similar to 403 Forbidden, but specifically for use when authentication is required and has failed or has not yet been provided."
    case paymentRequired = "paymentRequired: The content available on the server requires payment."
    case forbidden = "forbidden: The request was a valid request, but the server is refusing to respond to it."
    case notFound = "notFound: The requested resource could not be found but may be available in the future."
    case methodNotAllowed = "methodNotAllowed: A request method is not supported for the requested resource. e.g. a GET request on a form which requires data to be presented via POST"
    case notAcceptable = "notAcceptable: The requested resource is capable of generating only content not acceptable according to the Accept headers sent in the request."
    case proxyAuthenticationRequired = "proxyAuthenticationRequired: The client must first authenticate itself with the proxy."
    case requestTimeout = "equestTimeout: The server timed out waiting for the request."
    case conflict = "conflict: Indicates that the request could not be processed because of conflict in the request, such as an edit conflict between multiple simultaneous updates."
    case gone = "gone: Indicates that the resource requested is no longer available and will not be available again."
    case lengthRequired = "lengthRequired: The request did not specify the length of its content, which is required by the requested resource."
    case preconditionFailed = "preconditionFailed: The server does not meet one of the preconditions that the requester put on the request."
    case payloadTooLarge = "payloadTooLarge: The request is larger than the server is willing or able to process."
    case URITooLong = "URITooLong: The URI provided was too long for the server to process."
    case unsupportedMediaType = "unsupportedMediaType: The request entity has a media type which the server or resource does not support."
    case rangeNotSatisfiable = "rangeNotSatisfiable: The client has asked for a portion of the file (byte serving), but the server cannot supply that portion."
    case expectationFailed = "expectationFailed: The server cannot meet the requirements of the Expect request-header field."
    case teapot = "teapot: This HTTP status is used as an Easter egg in some websites."
    case misdirectedRequest = "misdirectedRequest: The request was directed at a server that is not able to produce a response."
    case unprocessableEntity = "unprocessableEntity: The request was well-formed but was unable to be followed due to semantic errors."
    case locked = "locked: The resource that is being accessed is locked."
    case failedDependency = "failedDependency: The request failed due to failure of a previous request (e.g., a PROPPATCH)."
    case upgradeRequired = "upgradeRequired: The client should switch to a different protocol such as TLS/1.0, given in the Upgrade header field."
    case preconditionRequired = "preconditionRequired: The origin server requires the request to be conditional."
    case tooManyRequests = "tooManyRequests: The user has sent too many requests in a given amount of time."
    case requestHeaderFieldsTooLarge = "requestHeaderFieldsTooLarge: The server is unwilling to process the request because either an individual header field, or all the header fields collectively, are too large."
    case noResponse = "noResponse: Used to indicate that the server has returned no information to the client and closed the connection."
    case unavailableForLegalReasons = "unavailableForLegalReasons: A server operator has received a legal demand to deny access to a resource or to a set of resources that includes the requested resource."
    case SSLCertificateError = "SSLCertificateError: An expansion of the 400 Bad Request response code, used when the client has provided an invalid client certificate."
    case SSLCertificateRequired = "SSLCertificateRequired: An expansion of the 400 Bad Request response code, used when a client certificate is required but not provided."
    case HTTPRequestSentToHTTPSPort = "HTTPRequestSentToHTTPSPort: An expansion of the 400 Bad Request response code, used when the client has made a HTTP request to a port listening for HTTPS requests."
    case clientClosedRequest = "clientClosedRequest: Used when the client has closed the request before the server could send a response."
    
    // Server Error - 5xx
    
    case internalServerError = "internalServerError: A generic error message, given when an unexpected condition was encountered and no more specific message is suitable."
    case notImplemented = "notImplemented: The server either does not recognize the request method, or it lacks the ability to fulfill the request."
    case badGateway = "badGateway: The server was acting as a gateway or proxy and received an invalid response from the upstream server."
    case serviceUnavailable = "serviceUnavailable: The server is currently unavailable (because it is overloaded or down for maintenance). Generally, this is a temporary state."
    case gatewayTimeout = "gatewayTimeout: The server was acting as a gateway or proxy and did not receive a timely response from the upstream server."
    case HTTPVersionNotSupported = "HTTPVersionNotSupported: The server does not support the HTTP protocol version used in the request."
    case variantAlsoNegotiates = "variantAlsoNegotiates: Transparent content negotiation for the request results in a circular reference."
    case insufficientStorage = "insufficientStorage: The server is unable to store the representation needed to complete the request."
    case loopDetected = "loopDetected: The server detected an infinite loop while processing the request."
    case notExtended = "notExtended: Further extensions to the request are required for the server to fulfill it."
    case networkAuthenticationRequired = "networkAuthenticationRequired: The client needs to authenticate to gain network access."

    
}

extension NetworkError: LocalizedError{
    var errorDescription: String? {return NSLocalizedString(rawValue, comment: "")}
}
