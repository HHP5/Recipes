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
    var description: String = ""
    var instruction: String?
    var images: [String]?
    var similarRecipes: [SimilarRecipes]?
    var hasSimilarRecipes: Bool = false

    func setRecipeAttributes(completion: @escaping (NetworkError?) -> Void) {
        
        ServiceLayer.request(router: Router.recipe(uuid: uuid)) { [weak self] (result: Result<RecipeResponse, Error>) in
            
            switch result {
            
            case .success(let response):
                
                let recipe = response.recipe
                
                self?.recipe = recipe
                
                self?.name = recipe.name
                
                if let description = recipe.description {
                    if !description.isEmpty {
                        self?.description = description
                    }
                }
                
                self?.instruction = recipe.instructions.replacingOccurrences(of: "<br>", with: "\n")
                
                self?.images = recipe.images
                
                self?.numberOfImages = recipe.images.count
                
                self?.similarRecipes = recipe.similar
                
                self?.numberOfButtons = recipe.similar?.count
                
                let whiteStar = "\u{2606}"
                let blackStar = "\u{2605}"
                
                let difficutlyStars = String(repeating: blackStar, count: recipe.difficulty) +
                    String(repeating: whiteStar, count: 5 - recipe.difficulty)
                
                self?.difficulty = "Difficulty: \(difficutlyStars)"
                
                if let similar = recipe.similar {
                    if !similar.isEmpty {
                        self?.hasSimilarRecipes = true
                    }
                }
                
                completion(nil)
                
            case .failure(let error):
                completion(error as? NetworkError)
            }
        }
    }
    
    func similarRecipePressed(for index: Int, completion: @escaping (DetailViewModelType) -> Void) {
        
        guard let similarRecipe = similarRecipes,
              let recipe = similarRecipes?[index].name else { return }
        
        similarRecipe.forEach { selectedRecipe in
            if selectedRecipe.name == recipe {
                completion(DetailViewModel(uuid: selectedRecipe.uuid))
            }
        }
    }
    
    // Передает массив изображений (для ведения подсчета) и изображение для отображения
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
