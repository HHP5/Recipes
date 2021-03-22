//
//  File.swift
//  Recipes
//
//  Created by Екатерина Григорьева on 22.03.2021.
//

import Foundation

enum NetworkingError: String, Error {
    case badURL = "A server with the specified hostname could not be found"
    case invalidResponse = "Invalid Response"
    case clientError = "An SSL error has occurred and a secure connection to the server cannot be made."
    case invalidRequest = "Invalid request. No value"
    case dataDecodingError = "Data Error"
}

extension NetworkingError: LocalizedError{
    var errorDescription: String? {return NSLocalizedString(rawValue, comment: "")}
}
