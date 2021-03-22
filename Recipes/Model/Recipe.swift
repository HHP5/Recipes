//
//  Recipes.swift
//  Test
//
//  Created by Екатерина Григорьева on 15.02.2021.
//

import Foundation

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


