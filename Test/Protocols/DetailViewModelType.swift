//
//  DetailViewModelType.swift
//  Test
//
//  Created by Екатерина Григорьева on 19.02.2021.
//

import Foundation

protocol DetailViewModelType: class{
    
    var numberOfRows: Int {get}
    
    var name: String {get}
    
    var difficulty: String {get}
    
    var description: String {get}
    
    var instruction: String {get}
    
    var images: [String] {get}
        
    var destinationVC: DetailViewController {get}
    
    var numberOfButtons: Int? {get set}
        
    var similarLabel: String {get}
    
    var titleForNavigationItem: String {get}
    
    func setSimilarButtons(closure: @escaping ()->())
    
    func similarRecipePressed(for index: Int)
    
    func collectionCellViewModel(for currentImage: String) -> CollectionCellModelType?
    
    func tableCellModel(for index: Int) -> ButtonCellModelType?
}
