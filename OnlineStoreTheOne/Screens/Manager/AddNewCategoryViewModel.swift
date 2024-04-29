//
//  AddNewCategoryViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 29.04.2024.
//

import Foundation


final class AddNewCategoryViewModel {
    var name: String?
    var image: String?
    
    var newCategory: NewCategory? {
        guard
            let name,
            let image
        else { return nil }
        
        let category = NewCategory(name: name, image: image)
        return category
    }
}
