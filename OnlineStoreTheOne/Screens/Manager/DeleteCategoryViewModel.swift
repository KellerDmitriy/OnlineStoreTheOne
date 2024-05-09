//
//  DeleteCategoryViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 29.04.2024.
//

import Foundation
import Combine

final class DeleteCategoryViewModel {
    @Published var id: String = "-"
    @Published var title: String = "-"
    
    let networkService: NetworkServiceProtocol
    
    //MARK: - Init
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func findCategoryByName(_ name: String) {
        Task {
            let result = await networkService.fetchAllCategories()
            switch result {
            case .success(let categories):
                let filteredCategories = categories.filter { $0.name?.lowercased().contains(name.lowercased()) ?? false }
                if let firstCategory = filteredCategories.first {
                    print("Найдена категория: \(firstCategory.name ?? "No name") с ID: \(firstCategory.id)")
                    id = "\(firstCategory.id)"
                    title = firstCategory.name ?? "-"
                } else {
                    print("Категория с названием '\(name)' не найдена.")
                }
            case .failure(let error):
                print("Ошибка при запросе категорий: \(error)")
            }
        }
    }
    
    func deleteCategory() {
        Task {
        guard let id = Int(id) else { return }
        
        let result = await networkService.deleteCategory(id: id)
            switch result {
            case .success():
                print("Category successfully deleted.")
            case .failure(let error):
                print("Error deleting category: \(error)")
            }
        }
    }
    
}
