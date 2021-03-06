//
//  ViewModelType.swift
//  Test
//
//  Created by Екатерина Григорьева on 22.02.2021.
//

import Foundation
import UIKit

protocol RecipeListViewModelType{
    var destinationVC: DetailViewController {get set}
    
    var numberOfRow: Int {get}
    
    var recipesForPrint: [RecipeStructure] {get set}
    
    func sortArray(for condition: SortedBy)
    
    func searchBarSearchButtonClicked(for searchText: String)
    
    func searchBarCancelButtonClicked()
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableCellModelType?
    
    func didSelectRow(at index: Int)
    
    func fetchingData(compelition: @escaping ()->())
}
