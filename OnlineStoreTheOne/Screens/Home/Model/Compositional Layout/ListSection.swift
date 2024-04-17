//
//  ListSection.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 15.04.2024.
//

import Foundation

enum ListSection {
    case textField([ListItem])
    case categories([ListItem])
    case products([ListItem])
    
    var items: [ListItem] {
        switch self {
        case    .textField(let items),
                .categories(let items),
                .products(let items):
            return items
        }
    }
    
    var count: Int {
        return items.count
    }
    
    var title: String {
        switch self {
        case .textField(_):
            return NSLocalizedString("Delivery address", comment: "")
        case .categories(_):
            return ""
        case .products(_):
            return NSLocalizedString("Products", comment: "")
        }
    }
}
