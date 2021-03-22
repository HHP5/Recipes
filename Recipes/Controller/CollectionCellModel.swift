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

    var imageURL: URL {
        let url = URL(string: imageURLString)
        return url!
    }

    var totalNumberImages: Int {
        return images.count
    }

    var currentImage: Int {
        var result = 0
        for i in 0...images.count - 1 where images.count > 1 {
            if images[i].contains(imageURLString) {
                result = i + 1
            }
        }
        return result
    }

    init(imageURL: String, images: [String]) {
        self.images = images
        self.imageURLString = imageURL
    }

}
