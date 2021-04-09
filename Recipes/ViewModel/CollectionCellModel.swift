//
//  CollectionCellModel.swift
//  Test
//
//  Created by Екатерина Григорьева on 18.02.2021.
//

import Foundation
import UIKit

class CollectionCellModel: CollectionCellModelType {
    var imageURLString: String
    var images: [String]

    var imageURL: URL? {
        return URL(string: imageURLString)
    }

    var totalNumberImages: Int {
        return images.count
    }
    
    var currentImageIndex: Int {
        let imageIndex = images.firstIndex { $0.contains(imageURLString)} ?? 0
        return imageIndex + 1
    }

    init(imageURL: String, images: [String]) {
        self.images = images
        self.imageURLString = imageURL
    }

}
