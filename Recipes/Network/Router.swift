//
//  Router.swift
//  Recipes
//
//  Created by Екатерина Григорьева on 23.03.2021.
//

import Foundation

enum Router {
    
    case allRecipes
    case recipe(uuid: String)
    
    var scheme: String {
        switch self {
        case .allRecipes, .recipe:
            return "https"
        }
    }
    
    var host: String {
        switch self {
        case .allRecipes, .recipe:
            return "test.kode-t.ru"
        }
    }
    
    var path: String {
        switch self {
        case .allRecipes:
            return "/recipes.json"
        case .recipe(let uuid):
            return "/recipes/\(uuid)"
        }
    }
    
    var method: String {
        switch self {
        case .allRecipes, .recipe:
            return "GET"
        }
    }

}
