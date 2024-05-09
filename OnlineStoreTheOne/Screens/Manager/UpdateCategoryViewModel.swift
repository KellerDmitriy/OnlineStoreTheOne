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
    
    let networkService: NetworkServiceProtocol
    
    //MARK: - Init
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    //MARK: - Public Methods
    var categoryUpdate: CategoryUpdate? {
        guard let name else { return nil }
        
        let category = CategoryUpdate(name: name)
        return category
    }
    
    func findCategoryByName(_ name: String) {
        Task {
            let result = await networkService.fetchAllCategories()
            switch result {
            case .success(let categories):
                let filteredCategories = categories.filter { $0.name?.lowercased().contains(name.lowercased()) ?? false }
                if let firstCategory = filteredCategories.first {
                    print("Найдена категория: \(firstCategory.name ?? "No name") с ID: \(firstCategory.id)")
//                    categoryView.setTextOnTitleField(firstCategory.name ?? "")
                    id = firstCategory.id
                } else {
                    print("Категория с названием '\(name)' не найдена.")
                }
            case .failure(let error):
                print("Ошибка при запросе категорий: \(error)")
            }
        }
    }
    
    func updateCategory() {
        Task {
        guard let id = id, let updateData = categoryUpdate else { return }
        
        let result = await networkService.updateCategory(id: id, updateData: updateData)
            switch result {
            case .success():
                print("Category successfully updated.")
            case .failure(let error):
                print("Error updating category: \(error)")
            }
        }
    }
    
}
