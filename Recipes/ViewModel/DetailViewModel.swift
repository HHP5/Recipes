//
//  DetailViewModel.swift
//  Test
//
//  Created by Екатерина Григорьева on 19.02.2021.
//

import Foundation
import UIKit

class DetailViewModel: DetailViewModelType {
    
    init(uuid: String) {
        self.uuid = uuid
    }
    var uuid: String
    var numberOfButtons: Int?
    var recipe: Recipe?
    var name: String?
    var numberOfImages: Int?
    var difficulty: String?
    var description: String?
    var instruction: String?
    var images: [String]?
    var similarLabel: String?
    var similarRecipes: [SimilarRecipes]?

    func setRecipeAttributes(completion: @escaping (NetworkError?) -> ()) {
        
        ServiceLayer.request(router: Router.oneRecipe(uuid: uuid)) { [weak self](result: Result<[String : Recipe], NetworkError>) in
            
            switch result{
            
            case .success(let recipe):
                if let key = recipe.keys.first, let newRecipe = recipe[key]{
                    
                    self?.recipe = newRecipe
                    
                    self?.name = newRecipe.name
                    
                    var resultString = ""
                    if newRecipe.description != "" && newRecipe.description != nil {
                        resultString = newRecipe.description!
                    }
                    self?.description = resultString
                    
                    self?.instruction = newRecipe.instructions.replacingOccurrences(of: "<br>", with: "\n")
                    
                    self?.images = newRecipe.images

                    self?.numberOfImages = newRecipe.images.count
                    
                    self?.similarRecipes = newRecipe.similar

                    self?.numberOfButtons = newRecipe.similar?.count
                    
                    
                    let unicodeWhiteStar = "\u{2606}"
                    let unicodeBlackStar = "\u{2605}"
                    
                    let difficutlyStars = String(repeating: unicodeBlackStar, count: newRecipe.difficulty) + String(repeating: unicodeWhiteStar, count: 5 - newRecipe.difficulty)
                    
                    self?.difficulty = "Difficulty: \(difficutlyStars)"
                    
                    var resultLabel = "" // На случай, если нет похожих рецептов, то и строка будет пустая
                    if newRecipe.similar!.count != 0 {
                        resultLabel = "SIMILAR RECIPE:"
                    }
                    self?.similarLabel = resultLabel
                    
                    completion(nil)

                }
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    

    func similarRecipePressed(for index: Int, completion: @escaping (DetailViewModelType)->()) {
        
        guard let similarRecipe = similarRecipes,
              let recipe = similarRecipes?[index].name else { return }
        
        similarRecipe.forEach { (selectedRecipe) in
            if selectedRecipe.name == recipe {
                completion(DetailViewModel(uuid: selectedRecipe.uuid))
            }
        }
    }
    
    //Передает массив изображений (для ведения подсчета) и изображение для отображения
    func collectionCellViewModel(for currentImage: String) -> CollectionCellModelType? {
        guard let images = images else { return nil }
        return CollectionCellModel(imageURL: currentImage, images: images )
    }
    
    func tableCellModel(for index: Int) -> ButtonCellModelType? {
        
        guard let similarRecipe = similarRecipes else { return nil }
        let nameSimilarRecipe = similarRecipe[index].name
        
        return ButtonCellModel(title: nameSimilarRecipe)
    }
}
