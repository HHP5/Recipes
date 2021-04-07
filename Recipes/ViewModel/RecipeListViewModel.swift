//
//  ViewModel.swift
//  Test
//
//  Created by Екатерина Григорьева on 19.02.2021.
//

import Foundation
import UIKit

class RecipeListViewModel: RecipeListViewModelType {
    private var recipes: [Recipe]?
    private var sortedArray: [Recipe] = []
    var recipesForPrint: [Recipe] = []

    func fetchingData(completion: @escaping(NetworkError?) -> Void) {
        ServiceLayer.request(router: Router.allRecipes) { [weak self] (result: Result<RecipeListResponse, Error>) in

            switch result {

            case .success(let result):

                self?.recipes = result.recipes
                self?.recipesForPrint = result.recipes
                self?.sortedArray = result.recipes

                completion(nil)

            case .failure(let error):

                completion(error as? NetworkError)

            }
        }
    }

    var numberOfRow: Int {
        return recipesForPrint.count
    }

    // Реализация сортировки
    func sortArray(by attribute: RecipesSortedBy) {
        switch attribute {
        case .lastUpdateDescending:
            sortedArray = recipesForPrint.sorted(by: { $0.lastUpdated > $1.lastUpdated })
        case .lastUpdateAscending:
            sortedArray = recipesForPrint.sorted(by: { $0.lastUpdated < $1.lastUpdated })
        case .name:
            sortedArray = recipesForPrint.sorted(by: { $0.name < $1.name })
        }
        recipesForPrint = sortedArray // Выводит на экран отсортированный массив
    }

    // Реализация поиска
    func searchBarSearchButtonClicked(for searchText: String) {
        var arrayForPrinting: [Recipe] = []

        sortedArray.forEach { recipe in

            var searchByDescription = false // Эта переменная изначально false, так как в рецепте может не быть описания

            let searchByName = recipe.name.lowercased().contains(searchText)

            // проверяет, есть ли описание и если есть, то начинает поиск в нем
            if let descriptionForOneRecipe = recipe.description {
                searchByDescription = descriptionForOneRecipe.lowercased().contains(searchText)
            }
            let searchByInstruction = recipe.instructions.lowercased().contains(searchText)

            if searchByName || searchByDescription || searchByInstruction {
                arrayForPrinting.append(recipe)
            }
            recipesForPrint = arrayForPrinting // Массив для отображения = массив, в котором найдено что нужно
        }
    }

    func searchBarCancelButtonClicked() {
        recipesForPrint = sortedArray
    }

    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableCellModelType? {
        let recipe = recipesForPrint[indexPath.row]
        return TableCellModel(recipe: recipe)
    }

    func didSelectRow(at index: Int) -> DetailViewModelType {
        let selectedRecipe = recipesForPrint[index]
        return DetailViewModel(uuid: selectedRecipe.uuid)
    }
}
