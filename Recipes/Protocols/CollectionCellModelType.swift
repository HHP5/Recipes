//
//  CollectionCellModelType.swift
//  Test
//
//  Created by Екатерина Григорьева on 19.02.2021.
//

import Foundation

protocol CollectionCellModelType: class {
    
    var imageURL: URL? {get}

    var imageURLString: String {get}
    
    var currentImage: Int {get}
    
    var totalNumberImages: Int {get}
    
}
