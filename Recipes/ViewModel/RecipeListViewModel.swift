//
//  ViewModel.swift
//  Test
//
//  Created by Екатерина Григорьева on 19.02.2021.
//

import Foundation
import UIKit

class RecipeListViewModel: RecipeListViewModelType {
    private var fetchedRecipes: [Recipe]?
    var recipes: [Recipe] = []
    private var sortBy: RecipesSortedBy = .none
    
    func fetchingData(completion: @escaping(NetworkError?) -> Void) {
        ServiceLayer.request(router: Router.allRecipes) { [weak self] (result: Result<RecipeListResponse, Error>) in
            
            switch result {
            
            case .success(let result):
                
                self?.fetchedRecipes = result.recipes
                self?.recipes = result.recipes
                
                DispatchQueue.main.async { completion(nil) }
                
            case .failure(let error):
                
                DispatchQueue.main.async {completion(error as? NetworkError)}
                
            }
        }
    }
    
    var numberOfRow: Int {
        return recipes.count
    }
    
    // Реализация сортировки
    func sortArray(by attribute: RecipesSortedBy) {
        sortBy = attribute
        recipes = sortingArray(for: recipes)
    }
    
    // Реализация поиска
    func searchBarSearchButtonClicked(for searchText: String) {
        recipes = sortingArray(for: fetchedRecipes).filter { recipe in
            
            let searchByName = recipe.name.lowercased().contains(searchText)
            let searchByDescription = recipe.description?.lowercased().contains(searchText) ?? false
            let searchByInstruction = recipe.instructions.lowercased().contains(searchText)
            
            return searchByName || searchByDescription || searchByInstruction
        }
    }
    
    func searchBarCancelButtonClicked() {
        recipes = sortingArray(for: fetchedRecipes)
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableCellModelType? {
        let recipe = recipes[indexPath.row]
        return TableCellModel(recipe: recipe)
    }
    
    func didSelectRow(at index: Int) -> DetailViewModelType {
        let selectedRecipe = recipes[index]
        return DetailViewModel(uuid: selectedRecipe.uuid)
    }
    
    private func sortingArray(for recipes: [Recipe]?) -> [Recipe] {
        guard let recipes = recipes else { return [] }
        
        switch sortBy {
        case .lastUpdateDescending:
            return recipes.sorted(by: { $0.lastUpdated > $1.lastUpdated })
        case .lastUpdateAscending:
            return recipes.sorted(by: { $0.lastUpdated < $1.lastUpdated })
        case .name:
            return recipes.sorted(by: { $0.name < $1.name })
        case .none:
            return recipes
        }
    }
}
