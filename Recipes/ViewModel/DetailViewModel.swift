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

                self?.handleResult(of: response.recipe)

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
        return CollectionCellModel(imageURL: currentImage, images: images)
    }

    func tableCellModel(for index: Int) -> ButtonCellModelType? {

        guard let similarRecipe = similarRecipes else { return nil }
        let nameSimilarRecipe = similarRecipe[index].name

        return ButtonCellModel(title: nameSimilarRecipe)
    }

    // MARK: - HANDLE RESULT
    
    private func handleResult(of recipe: Recipe) {
        self.recipe = recipe

        handleName(for: recipe.name)
        handleDescription(for: recipe.description)
        handleInstruction(for: recipe.instructions)
        handleImages(for: recipe.images)
        handleSimilar(for: recipe.similar)
        handleDifficutly(for: recipe.difficulty)

    }

    private func handleDifficutly(for difficulty: Int) {
        let whiteStar = "\u{2606}"
        let blackStar = "\u{2605}"

        let difficutlyStars = String(repeating: blackStar, count: difficulty) +
            String(repeating: whiteStar, count: 5 - difficulty)

        self.difficulty = "Difficulty: \(difficutlyStars)"
    }

    private func handleSimilar(for similar: [SimilarRecipes]?) {

        guard let similar = similar else { return }

        self.similarRecipes = similar
        self.numberOfButtons = similar.count

        if !similar.isEmpty {
            self.hasSimilarRecipes = true
        }
    }

    private func handleDescription(for description: String?) {

        guard let description = description else { return }

        if !description.isEmpty {
            self.description = description
        }
    }

    private func handleImages(for images: [String]) {

        self.images = images
        self.numberOfImages = images.count
    }

    private func handleInstruction(for instruction: String) {
        self.instruction = instruction.replacingOccurrences(of: "<br>", with: "\n")
    }

    private func handleName(for name: String) {
        self.name = name
    }
}
