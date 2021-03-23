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

    func similarRecipePressed(for index: Int, completion: @escaping (Result<DetailViewModelType,NetworkError>)->()) {

//        let fetchingData = FetchingData()
        guard let similarRecipe = similarRecipes,
              let recipe = similarRecipes?[index].name else { return }

        similarRecipe.forEach { (selectedRecipe) in
            if selectedRecipe.name == recipe {

                // Запрашивает и передает данные по выбранному рецепту

                ServiceLayer.request(router: Router.oneRecipe(uuid: selectedRecipe.uuid)) { (result:Result<[String : Recipe], NetworkError>) in
                    
                    switch result{
                    
                    case .success(let recipe):
                        
                        if let key = recipe.keys.first, let newRecipe = recipe[key]{
                            completion(.success(DetailViewModel(recipe: newRecipe)))
                            
                        }
                        
                    case .failure(let error):
                        
                        completion(.failure(error))
                    
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
