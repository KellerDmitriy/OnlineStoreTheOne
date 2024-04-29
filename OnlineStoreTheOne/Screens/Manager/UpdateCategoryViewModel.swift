//
//  UpdateCategoryViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 29.04.2024.
//

import Foundation

final class UpdateCategoryViewModel {
    var id: Int?
    var name: String?
    
    var categoryUpdate: CategoryUpdate? {
        guard let name else { return nil }
        
        let category = CategoryUpdate(name: name)
        return category
    }
}
