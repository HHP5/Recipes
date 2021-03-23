//
//  DetailViewModelType.swift
//  Test
//
//  Created by Екатерина Григорьева on 19.02.2021.
//

import Foundation

protocol DetailViewModelType: class{
    
    var numberOfImages: Int? {get}
    
    var name: String? {get}
    
    var difficulty: String? {get}
    
    var description: String? {get}
    
    var instruction: String? {get}
    
    var images: [String]? {get}
            
    var numberOfButtons: Int? {get set}
        
    var similarLabel: String? {get}
        
    func setRecipeAttributes(completion: @escaping (NetworkError?)->())
//    func setSimilarButtons(closure: @escaping ()->())
    
//    func didSelectRow(at index: Int) -> DetailViewModelType
    func similarRecipePressed(for index: Int, completion: @escaping (DetailViewModelType)->())
    
    func collectionCellViewModel(for currentImage: String) -> CollectionCellModelType?
    
    func tableCellModel(for index: Int) -> ButtonCellModelType?
}
