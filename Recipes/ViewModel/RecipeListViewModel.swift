//
//  ViewModel.swift
//  Test
//
//  Created by Екатерина Григорьева on 19.02.2021.
//

import Foundation
import UIKit

class RecipeListViewModel: RecipeListViewModelType {
    var didStartRequest: (() -> Void)?
    
    var didFinishRequest: (() -> Void)?
    
    var didUpdateData: (() -> Void)?
    
    var didReceiveError: ((Error) -> Void)?
    
    private var fetchedRecipes: [Recipe] = []
    var recipes: [Recipe] = []
    private var sortBy: RecipesSortedType = .none
    private var serviceLayer = ServiceLayer()
	
    func fetchingRecipes() {
        didStartRequest?()
		
        serviceLayer.request(router: Router.allRecipes) { [weak self] (result: Result<RecipeListResponse, Error>) in
            
            self?.didFinishRequest?()

            switch result {
            case .success(let result):
                
                self?.fetchedRecipes = result.recipes
                self?.recipes = result.recipes
                                
                DispatchQueue.main.async {
					
                    self?.didUpdateData?()
					
				}
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    
                    self?.didReceiveError?(error)
                    
                }
                
            }
        }
    }
    
    var numberOfRow: Int {
        return recipes.count
    }
    
    // Реализация сортировки
    func sortArray(by attribute: RecipesSortedType) {
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
    
    private func sortingArray(for recipes: [Recipe]) -> [Recipe] {
        
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
