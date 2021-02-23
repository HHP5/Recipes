//
//  Recipes.swift
//  Test
//
//  Created by Екатерина Григорьева on 15.02.2021.
//

import Foundation

struct EntireRecipeList: Codable {
    let recipes: [RecipeStructure]
}

struct OneRecipe: Codable {
    let recipe: RecipeStructure
}

struct RecipeStructure: Codable {
    var uuid: String
    var name: String
    var images: [String]
    let lastUpdated: Int
    var description: String?
    var instructions: String
    let difficulty: Int
    var similar: [SimilarRecipes]?
}

struct SimilarRecipes: Codable {
    var uuid: String
    var name: String
}
