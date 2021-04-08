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
    private var sortAttribute: RecipesSortedBy = .none
    
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
        sortAttribute = attribute
        sortingArray(for: recipesForPrint)
    }
    
    // Реализация поиска
    func searchBarSearchButtonClicked(for searchText: String) {
        recipesForPrint = recipesForPrint.filter { recipe in
            
            let searchByName = recipe.name.lowercased().contains(searchText)
            let searchByDescription = recipe.description?.lowercased().contains(searchText) ?? false
            let searchByInstruction = recipe.instructions.lowercased().contains(searchText)
            
            return searchByName || searchByDescription || searchByInstruction
        }
    }
    
    func searchBarCancelButtonClicked() {
        guard let recipes = recipes else { return  }
        sortingArray(for: recipes)
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableCellModelType? {
        let recipe = recipesForPrint[indexPath.row]
        return TableCellModel(recipe: recipe)
    }
    
    func didSelectRow(at index: Int) -> DetailViewModelType {
        let selectedRecipe = recipesForPrint[index]
        return DetailViewModel(uuid: selectedRecipe.uuid)
    }
    
    private func sortingArray(for recipes: [Recipe]) {

        switch sortAttribute {
        case .lastUpdateDescending:
            recipesForPrint = recipes.sorted(by: { $0.lastUpdated > $1.lastUpdated })
        case .lastUpdateAscending:
            recipesForPrint = recipes.sorted(by: { $0.lastUpdated < $1.lastUpdated })
        case .name:
            recipesForPrint = recipes.sorted(by: { $0.name < $1.name })
        case .none:
            recipesForPrint = recipes
        }
    }
}
