//
//  ViewModel.swift
//  Test
//
//  Created by Екатерина Григорьева on 19.02.2021.
//

import Foundation
import UIKit

class RecipeListViewModel: RecipeListViewModelType {

    private var isSoarted = false // указывает на то, была ли сортировка (это нужно для правильной работы поиска)
    private var recipes: RecipesList?
    var recipesForPrint: RecipesList = []
    
    func fetchingData(completion: @escaping(NetworkError?) -> ()) {
        
        ServiceLayer.request(router: Router.allRecipes) { [weak self] (result:Result<[String : RecipesList], NetworkError>) in
            switch result{
            case .success(let result):
                
                if let key = result.keys.first, let recipesList = result[key]{
                    
                    self?.recipes = recipesList
                    self?.recipesForPrint = recipesList
                    
                    completion(nil)
                    
                }else{
                    
                }
                
            case .failure(let error):
                completion(error)
            }
        
        }
    }
    
    

    var numberOfRow: Int {
        return recipesForPrint.count
    }

    private var sortedArray = [Recipe]()

    // Реализация сортировки
    func sortArray(by attribute: RecipesSortedBy){

        let recipesForSort = recipesForPrint
        isSoarted = true
        
        switch attribute {
        case .lastUpdateAscending:
            sortedArray = recipesForSort.sorted(by: { $0.lastUpdated > $1.lastUpdated })
        case .lastUpdateDescending:
            sortedArray = recipesForSort.sorted(by: { $0.lastUpdated < $1.lastUpdated })
        case .name:
            sortedArray = recipesForSort.sorted(by: { $0.name < $1.name })
        }
        recipesForPrint = sortedArray //Выводит на экран отсортированный массив
    }

    //Реализация поиска
    func searchBarSearchButtonClicked(for searchText: String) {
        let recipesForSearch = recipesForPrint
        var arrayForPrinting = [Recipe]()

        recipesForSearch.forEach { (recipe) in

            var searchByDescription = false // Эта переменная изначально false, так как в рецепте может не быть описания

            let searchByName = recipe.name.lowercased().contains(searchText)

            if let descriptionForOneRecipe = recipe.description { // проверяет, есть ли описание и если есть, то начинает поиск в нем
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
        guard let recipes = recipes else { return }
        // На случай если рецепты были отсортированы, а уже потом произведен поиск. После отмены все вернется к отсортированному виду
        recipesForPrint = isSoarted ? sortedArray : recipes
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
