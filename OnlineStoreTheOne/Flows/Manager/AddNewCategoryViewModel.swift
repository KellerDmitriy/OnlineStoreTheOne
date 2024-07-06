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
    
    let networkService: NetworkServiceProtocol
    
    //MARK: - Init
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    //MARK: - Public Methods
    var newCategory: NewCategory? {
        guard
            let name,
            let image
        else { return nil }
        
        let category = NewCategory(name: name, image: image)
        return category
    }
    
    func createNewCategory() {
        Task {
            guard let category = newCategory else { return }
            
            let result = await networkService.createCategory(category: category)
            switch result {
            case .success(let category):
                print("Category successfully created with name: \(category.name)")
            case .failure(let error):
                print("Error creating category: \(error)")
            }
        }
    }
    
}
