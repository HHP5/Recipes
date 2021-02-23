//
//  ViewModel.swift
//  Test
//
//  Created by Екатерина Григорьева on 19.02.2021.
//

import Foundation
import UIKit

class ViewModel: ViewModelType {

    var isSoarted = false // указывает на то, была ли сортировка (это нужно для правильной работы поиска)
    var destinationVC = DetailViewController()
    private var fetchedData = FetchingData()
    private var recipes: [RecipeStructure]?
    var recipesForPrint: [RecipeStructure] = []

    func fetchingData(compelition closure: @escaping() -> ()) {
        fetchedData.fetchAllRecipes { [weak self] recipe in
            self?.recipes = recipe
            self?.recipesForPrint = recipe
            closure()
        }
    }

    var numberOfRow: Int {
        return recipesForPrint.count
    }

    private var sortedArray = [RecipeStructure]()

    // Реализация сортировки
    func sortArray(for condition: String) {

        let recipesForSort = recipesForPrint
        isSoarted = true
        switch condition {
        case "Last Update ↓":
            sortedArray = recipesForSort.sorted(by: { $0.lastUpdated > $1.lastUpdated })
        case "Last Update ↑":
            sortedArray = recipesForSort.sorted(by: { $0.lastUpdated < $1.lastUpdated })
        case "Name":
            sortedArray = recipesForSort.sorted(by: { $0.name < $1.name })
        default:
            print("Error in sorting")
        }
        recipesForPrint = sortedArray //Выводит на экран отсортированный массив
    }

    //Реализация поиска
    func searchBarSearchButtonClicked(for searchText: String) {
        let recipesForSearch = recipesForPrint
        var arrayForPrinting = [RecipeStructure]()

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

    func didSelectRow(at index: Int) {

        let selectedRecipe = recipesForPrint[index]
        //Запрос по выбранному рецепту (потому что similar рецептов нет в общем запросе, для каждого рецепта отдельно)
        fetchedData.fetchingRecipe(for: selectedRecipe.uuid) { (recipe) in
            self.destinationVC.detailModel = DetailViewModel(recipe: recipe)
        }
    }
}
