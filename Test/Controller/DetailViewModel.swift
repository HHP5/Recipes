//
//  DetailViewModel.swift
//  Test
//
//  Created by Екатерина Григорьева on 19.02.2021.
//

import Foundation
import UIKit

class DetailViewModel: DetailViewModelType {

    var destinationVC = DetailViewController()

    var recipe: RecipeStructure

    init(recipe: RecipeStructure) {
        self.recipe = recipe
    }

    var similarRecipes: [SimilarRecipes]?

    var name: String {
        return recipe.name
    }

    func setSimilarButtons(closure: @escaping () -> ()) {
        guard let similar = recipe.similar else { return }
        self.similarRecipes = similar
        self.numberOfButtons = similarRecipes!.count
        closure()
    }

    var difficulty: String {
        // Отображение сложности рецепта как закрашенных звезд из 5
        let difficutlyStars = String(repeating: "\u{2605}", count: recipe.difficulty) + String(repeating: "\u{2606}", count: 5 - recipe.difficulty)
        return "Difficulty: \(difficutlyStars)"
    }

    var numberOfButtons: Int?

    var description: String {
        var resultString = ""
        if recipe.description != "" && recipe.description != nil {
            resultString = recipe.description!
        }
        return resultString
    }

    var instruction: String {
        // Возращает отредактированный массив( без <br>)
        return recipe.instructions.replacingOccurrences(of: "<br>", with: "\n")
    }
    var numberOfRows: Int {
        return recipe.images.count
    }

    var images: [String] {
        return recipe.images
    }

    var similarLabel: String {
        var resultLabel = "" // На случай, если нет похожих рецептов, то и строка будет пустая
        if similarRecipes?.count != 0 {
            resultLabel = "SIMILAR RECIPE:"
        }
        return resultLabel
    }

    var titleForNavigationItem: String { //Нашла некоторые подходящие unicode scalar для рецептов
        var symbol = "\u{1F372}"
        switch recipe.name {
        case "Tomato Puff Pastry Bites":
            symbol = "\u{1F345}"
        case "Minted Orzo with Tomatoes":
            symbol = "\u{1F35A}"
        case "Ham or Sausage Quiche":
            symbol = "\u{1F967}"
        case "Pan Roasted Chicken with Lemon, Garlic, Green Beans and Red Potatoes":
            symbol = "\u{1F357}"
        default:
            symbol = "\u{1F372}"
        }
        return "R E C I P E " + symbol
    }


    func similarRecipePressed(for index: Int) {

        let fetchingData = FetchingData()
        guard let nameSimilarRecipe = similarRecipes?[index].name,
            let similarRecipe = similarRecipes else { return }

        similarRecipe.forEach { (element) in
            if element.name == nameSimilarRecipe {
                let uuidSimilarRecipe = element.uuid

                // Запрашивает и передает данные по выбранному рецепту
                fetchingData.fetchData(for: uuidSimilarRecipe) { [self] (recipe: OneRecipe) in
                    destinationVC.detailModel = DetailViewModel(recipe: recipe.recipe)
                }
            }
        }
    }

    //Передает массив изображений (для ведения подсчета) и изображение для отображения
    func collectionCellViewModel(for currentImage: String) -> CollectionCellModelType? {

        return CollectionCellModel(imageURL: currentImage, images: images)
    }

    func tableCellModel(for index: Int) -> ButtonCellModelType? {

        guard let nameSimilarRecipe = similarRecipes?[index].name else { return nil }
        return ButtonCellModel(title: nameSimilarRecipe)
    }
}
