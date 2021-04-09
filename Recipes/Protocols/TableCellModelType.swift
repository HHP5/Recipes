//
//  TableCellModelType.swift
//  Test
//
//  Created by Екатерина Григорьева on 19.02.2021.
//

import Foundation

protocol TableCellModelType: class {
    var name: String {get}
    
    var description: String {get}
    
    var imageURL: URL? {get}
    
}
