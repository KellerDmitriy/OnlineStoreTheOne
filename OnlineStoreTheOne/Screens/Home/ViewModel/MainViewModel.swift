//
//  MainViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 19.04.2024.
//

import Foundation

final class MainViewModel {
    
    var products: [Products] = []
    var categories: [Category] = []
    
    let networkService = NetworkService.shared
    let storageService = RealmStorageService.shared
    
    func fetchProducts() {
        Task {
            let result = await networkService.fetchAllProducts()
            switch result {
            case .success(let products):
                self.products = products
            case .failure(let error):
                print("Error fetching products: \(error)")
            }
        }
    }
    
    func fetchCategory() {
        Task {
            let result = await networkService.fetchCategory()
            
            switch result {
            case .success(let categories):
                self.categories = categories
            case .failure(let error):
                print("Error fetching products: \(error)")
            }
        }
    }
}
