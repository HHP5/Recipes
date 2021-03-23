//
//  Router.swift
//  Recipes
//
//  Created by Екатерина Григорьева on 23.03.2021.
//

import Foundation

enum Router {
    
    case allRecipes
    case oneRecipe(uuid: String)
    
    var scheme: String{
        switch self {
        case .allRecipes, .oneRecipe:
            return "https"
        }
    }
    
    var host: String {
        switch self {
        case .allRecipes, .oneRecipe:
            return "test.kode-t.ru"
        }
    }
    
    var path: String {
        switch self {
        case .allRecipes:
            return "/recipes.json"
        case .oneRecipe(let uuid):
            return "/recipes/\(uuid)"
        }
    }
    
    var method: String {
        switch self {
        case .allRecipes, .oneRecipe:
            return "GET"
        }
    }

}
