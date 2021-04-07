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

    var currentImage: Int {
        var result = 0
        for x in 0...images.count - 1 where images.count > 1 {
            if images[x].contains(imageURLString) {
                result = x + 1
            }
        }
        return result
    }

    init(imageURL: String, images: [String]) {
        self.images = images
        self.imageURLString = imageURL
    }

}
