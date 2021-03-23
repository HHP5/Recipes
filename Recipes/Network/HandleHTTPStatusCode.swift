//
//  HandleHTTPStatusCode.swift
//  Recipes
//
//  Created by Екатерина Григорьева on 23.03.2021.
//

import Foundation

extension HTTPURLResponse {
    
    var status: HTTPStatusCode? {
        return HTTPStatusCode(rawValue: statusCode)
    }
    
    
    func handleHTTPStatusCode() -> NetworkError{
        
        switch self.status {
        
        case .continue, .switchingProtocols, .processing, .ok, .created, .accepted, .nonAuthoritativeInformation,.noContent,.resetContent,.partialContent,.multiStatus,.alreadyReported,.IMUsed, .none: return .none
            
        // Redirection - 3xx
        
        case .multipleChoices: return .multipleChoices
        case .movedPermanently: return .movedPermanently
        case .found: return .found
        case .seeOther: return .seeOther
        case .notModified: return .notModified
        case .useProxy: return .useProxy
        case .switchProxy: return .switchProxy
        case .temporaryRedirect: return .temporaryRedirecte
        case .permenantRedirect: return .permenantRedirect
            
        // Client Error - 4xx
        
        case .badRequest: return .badRequest
        case .unauthorized: return .unauthorized
        case .paymentRequired: return .paymentRequired
        case .forbidden: return .forbidden
        case .notFound: return .notFound
        case .methodNotAllowed: return .methodNotAllowed
        case .notAcceptable: return .notAcceptable
        case .proxyAuthenticationRequired: return .proxyAuthenticationRequired
        case .requestTimeout: return .requestTimeout
        case .conflict: return .conflict
        case .gone: return .gone
        case .lengthRequired: return .lengthRequired
        case .preconditionFailed: return .preconditionFailed
        case .payloadTooLarge: return .payloadTooLarge
        case .URITooLong: return .URITooLong
        case .unsupportedMediaType: return .unsupportedMediaType
        case .rangeNotSatisfiable: return .rangeNotSatisfiable
        case .expectationFailed: return .expectationFailed
        case .teapot: return .teapot
        case .misdirectedRequest: return .misdirectedRequest
        case .unprocessableEntity: return .unprocessableEntity
        case .locked: return .locked
        case .failedDependency: return .failedDependency
        case .upgradeRequired: return .upgradeRequired
        case .preconditionRequired: return .preconditionRequired
        case .tooManyRequests: return .tooManyRequests
        case .requestHeaderFieldsTooLarge: return .requestHeaderFieldsTooLarge
        case .noResponse: return .noResponse
        case .unavailableForLegalReasons: return .unavailableForLegalReasons
        case .SSLCertificateError: return .SSLCertificateError
        case .SSLCertificateRequired: return .SSLCertificateRequired
        case .HTTPRequestSentToHTTPSPort: return .HTTPRequestSentToHTTPSPort
        case .clientClosedRequest: return .clientClosedRequest
            
        // Server Error - 5xx
        
        case .internalServerError: return .internalServerError
        case .notImplemented: return .notImplemented
        case .badGateway: return .badGateway
        case .serviceUnavailable: return .serviceUnavailable
        case .gatewayTimeout: return .gatewayTimeout
        case .HTTPVersionNotSupported: return .HTTPVersionNotSupported
        case .variantAlsoNegotiates: return .variantAlsoNegotiates
        case .insufficientStorage: return .insufficientStorage
        case .loopDetected: return .loopDetected
        case .notExtended: return .notExtended
        case .networkAuthenticationRequired: return .networkAuthenticationRequired
            
        }
    }
}
