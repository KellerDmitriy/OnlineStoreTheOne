//
//  HomeViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 19.04.2024.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func dataUpdated()
}

final class HomeViewModel {
    
    var products: [Products] = []
    var categories: [Category] = []
    
    var dataUpdated: (() -> Void)?
    
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
    public func getData(id: Int) {
        ///получение категории по  идентификатору
        guard let category = categories.first(where: { $0.id == id }) else {
            print("Category with id \(id) not found")
            return
        }
        ///запрос продуктов для выбранной категории
        fetchProducts(for: category)
    }

    func fetchProducts(for category: Category) {
        Task {
            let result: Result<[Products], NetworkError> = await networkService.fetchProducts(with: category)
            
            if case let .success(data) = result {
                self.products = data
                dataUpdated?()
            } else if case let .failure(error) = result {
                print("Failed to fetch data: \(error)")
            }
        }
    }

    func fetchSearchProducts(_ title: String) {
        Task {
            let result = await networkService.fetchSearchProducts(by: title)
            
            switch result {
            case .success(let data):
                self.products = data
                dataUpdated?()
            case .failure(let error):
                print("Failed to fetch products: \(error)")
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

