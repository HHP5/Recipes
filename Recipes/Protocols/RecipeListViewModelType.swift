//
//  ViewModelType.swift
//  Test
//
//  Created by Екатерина Григорьева on 22.02.2021.
//

import Foundation
import UIKit

protocol RecipeListViewModelType {
    var numberOfRow: Int {get}
    
    var recipes: [Recipe] {get set}

    func sortArray(by attribute: RecipesSortedBy)

    func searchBarSearchButtonClicked(for searchText: String)
    
    func searchBarCancelButtonClicked()
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableCellModelType?
    
    func didSelectRow(at index: Int) -> DetailViewModelType

    func fetchingData(completion: @escaping (NetworkError?) -> Void)
}
