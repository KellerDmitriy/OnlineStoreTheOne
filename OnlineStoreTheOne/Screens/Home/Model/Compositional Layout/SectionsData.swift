//
//  MockData.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 15.04.2024.
//

import Foundation

enum HomeSection: Int, Hashable {
    case searchField
    case categories
    case products
    
    var title: String {
        switch self {
        case .searchField:
            return NSLocalizedString("Delivery address", comment: "")
        case .categories:
            return ""
        case .products:
            return NSLocalizedString("Products", comment: "")
        }
    }
}

struct SectionsData {
    
    static let shared = SectionsData()
    
    let sections: [HomeSection] = [
        .searchField,
        .categories,
        .products
    ]
    private init() {}
}

