//
//  Recipes.swift
//  Test
//
//  Created by Екатерина Григорьева on 15.02.2021.
//

import Foundation

struct RecipeListResponse: Codable {
    let recipes: [Recipe]
}

struct RecipeResponse: Codable {
    let recipe: Recipe
}

struct Recipe: Codable {
    var uuid: String
    var name: String
    var images: [String]
    let lastUpdated: Int
    var description: String?
    var instructions: String
    let difficulty: Int
    var similar: [SimilarRecipes]?
}
