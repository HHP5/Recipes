//
//  SortedBy.swift
//  Recipes
//
//  Created by Екатерина Григорьева on 06.03.2021.
//

import Foundation

enum RecipesSortedType {
    
    case name
    case lastUpdateDescending
    case lastUpdateAscending
    case none
	
	var title: String {
		
		switch self {
		case .name:
			return "Name"
		case .lastUpdateAscending:
			return "Last Update ↑"
		case .lastUpdateDescending:
			return "Last Update ↓"
		case .none:
			return ""
		}
	}
}
