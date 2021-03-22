//
//  File.swift
//  Recipes
//
//  Created by Екатерина Григорьева on 22.03.2021.
//

import Foundation

enum NetworkingError: String, Error {

    case invalidResponse = "Invalid Response"
    case clientError = "An SSL error has occurred and a secure connection to the server cannot be made."
    case invalidRequest, badURL = "Invalid request. No value"
    case dataDecodingError = "data error"
}

extension NetworkingError: LocalizedError{
    var errorDescription: String? {return NSLocalizedString(rawValue, comment: "")}
}
