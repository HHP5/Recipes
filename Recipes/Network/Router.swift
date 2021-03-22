////
////  Router.swift
////  Recipes
////
////  Created by Екатерина Григорьева on 09.03.2021.
////
//
//import Foundation
//
//enum Router{
//    
//    //1.Requests
//    case getRecipesList
//    case getCertainRecipe
//    
//    //2
//    var scheme: String{
//        switch self {
//        case .getCertainRecipe, .getRecipesList:
//            return "https"
//        }
//    }
//    
//    var host: String{
//        switch self {
//        case .getCertainRecipe, .getRecipesList:
//            return "test.kode-t.ru"
//        }
//    }
//    
//    var path: String{
//        switch self {
//        case .getRecipesList:
//            return "/recipes.json"
//        case .getCertainRecipe:
//            return "c1e9-11e6-a4a6-cec0c932ce01"
//        }
//    }
//    
////    var parameters: [URLQueryItem]{
////        switch self {
////        case .getRecipesList:
////            return [URLQueryItem(name: <#T##String#>, value: <#T##String?#>)]
////        default:
////            <#code#>
////        }
////    }
//    
//    var method: String {
//        switch self {
//        case .getRecipesList, .getCertainRecipe:
//            return "GET"
//        }
//      }
//    
//}
