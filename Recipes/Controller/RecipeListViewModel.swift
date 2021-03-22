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
    private var fetchedData = FetchingData()
    private var recipes: [Recipe]?
    var recipesForPrint: [Recipe] = []

    func fetchingData(compelition closure: @escaping() -> ()) {
        fetchedData.fetchData { [weak self] (result: Result<[String:[Recipe]], NetworkingError>) in

            switch result{
            
            case .success(let recipes):
                
                if let key = recipes.keys.first, let recipesList = recipes[key]{
                    self?.recipes = recipesList
                    self?.recipesForPrint = recipesList
                    closure()
                }
                
            case .failure(let error):
                
                print(error.errorDescription as Any)
                
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

        recipesForSearch.forEach { (oneRecipe) in

            var searchByDescription = false // Эта переменная изначально false, так как в рецепте может не быть описания

            let searchByName = oneRecipe.name.lowercased().contains(searchText)

            if let descriptionForOneRecipe = oneRecipe.description { // проверяет, есть ли описание и если есть, то начинает поиск в нем
                searchByDescription = descriptionForOneRecipe.lowercased().contains(searchText)
            }
            let searchByInstruction = oneRecipe.instructions.lowercased().contains(searchText)

            if searchByName || searchByDescription || searchByInstruction {
                arrayForPrinting.append(oneRecipe)
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

    func didSelectRow(at index: Int, completion: @escaping (DetailViewModelType)->()) {
        let selectedRecipe = recipesForPrint[index]
//        Запрос по выбранному рецепту (потому что similar рецептов нет в общем запросе, для каждого рецепта отдельно)
        fetchedData.fetchData(for: selectedRecipe.uuid) {(result: Result<[String:Recipe], NetworkingError>) in//
            switch result{
            
            case.success(let recipe):
                if let key = recipe.keys.first, let newRecipe = recipe[key]{
                    completion(DetailViewModel(recipe: newRecipe))

                }

            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
    }
}
