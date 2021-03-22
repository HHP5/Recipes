////
////  Model Types.swift
////  Recipes
////
////  Created by Екатерина Григорьева on 09.03.2021.
////
//
//import Foundation
//import UIKit
//
//struct EntireRecipeList<T: Decodable>: Decodable {
//    let recipes: [T]
//}
//
//struct OneRecipe<T: Decodable>: Decodable {
//    let recipe: T
//}
//
//struct Recipe: Identifiable {
//    
//    var id: String
//    var name: String
//    var images: [String]
//    let lastUpdated: Int
//    var description: String?
//    var instructions: String
//    let difficulty: Int
//    var similar: [SimilarRecipes]?
//}
//extension Recipe: Decodable{
//    enum CodingKeys: String, CodingKey {
//        case name,images,lastUpdated,description,instructions,difficulty,similar
//        case id = "uuid"
//    }
//}
//
//struct SimilarRecipes: Codable {
//    var uuid: String
//    var name: String
//}
//
