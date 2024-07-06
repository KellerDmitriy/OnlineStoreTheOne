//
//  CustomViewWithPickerViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 28.04.2024.
//

import Foundation
import Combine

final class CustomViewWithPickerViewModel {
    
    @Published
    var categoryList: [String] = []
    var categories: [Int: String] = [:]
    
    init(categoryList: [String]) {
        self.categoryList = categoryList
    }
    
    func separateCategories(_ allCategories: [Category]) {
        allCategories.forEach { category in
            categoryList.append(category.name ?? "nil")
            categories[category.id] = category.name
        }
    }
    
    func getCategoryId(_ name: String) -> Int? {
        categories.first(where: { $0.value == name })?.key
    }
}
