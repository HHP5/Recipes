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
        var resultString = ""
        if recipe.description != "" && recipe.description != nil {
            resultString = recipe.description!
        }
        return resultString
    }

    var imageURL: URL {
        return URL(string: recipe.images[0])!
    }

    init(recipe: Recipe) {
        self.recipe = recipe
    }

}
