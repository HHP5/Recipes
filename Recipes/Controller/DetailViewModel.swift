//
//  DetailViewModel.swift
//  Test
//
//  Created by Екатерина Григорьева on 19.02.2021.
//

import Foundation
import UIKit

class DetailViewModel: DetailViewModelType {


    var recipe: Recipe

    init(recipe: Recipe) {
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
        let unicodeWhiteStar = "\u{2606}"
        let unicodeBlackStar = "\u{2605}"
        let difficutlyStars = String(repeating: unicodeBlackStar, count: recipe.difficulty) + String(repeating: unicodeWhiteStar, count: 5 - recipe.difficulty)
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

    func similarRecipePressed(for index: Int, completion: @escaping (DetailViewModelType)->()) {

        let fetchingData = FetchingData()
        guard let similarRecipe = similarRecipes,
              let selectedRecipe = similarRecipes?[index].name else { return }

        similarRecipe.forEach { (recipe) in
            if recipe.name == selectedRecipe {
                let selectedRecipeUUID = recipe.uuid

                // Запрашивает и передает данные по выбранному рецепту

                fetchingData.fetchData(for: selectedRecipeUUID) { (result: Result<[String:Recipe], NetworkingError>) in
//                fetchingData.fetchData(for: selectedRecipeUUID) { (result: Result<OneRecipe, NSError>) in

                    switch result{

                    case.success(let recipe):
                        if let key = recipe.keys.first, let newRecipe = recipe[key]{
                            completion(DetailViewModel(recipe: newRecipe))

                        }
//                        completion(DetailViewModel(recipe: recipe.recipe))

                    case .failure(let error):

                        print(error.rawValue)

                    }
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
