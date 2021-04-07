//
//  TableCellModel.swift
//  Test
//
//  Created by Екатерина Григорьева on 19.02.2021.
//

import Foundation
import UIKit

class TableCellModel: TableCellModelType {
    
    private var recipe: Recipe
    
    var name: String {
        return recipe.name
    }
    
    var description: String {
        guard let description = recipe.description else { return "" }
        return description
    }
    
    var imageURL: URL? {
        return URL(string: recipe.images[0])
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
}
