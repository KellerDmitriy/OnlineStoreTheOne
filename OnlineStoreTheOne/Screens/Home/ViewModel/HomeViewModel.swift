//
//  HomeViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 19.04.2024.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    var categories: [Category] = []
    
    @Published var products: [Products] = []
    @Published var searchText = ""
    
    var subscription: Set<AnyCancellable> = []
    
    let networkService = NetworkService.shared
    let storageService = RealmStorageService.shared
    
    //MARK: - Init
    init() {

    }
    
    //MARK: - Observe Methods
    func observe() {
        $searchText
            .sink {  searchText in
            }
            .store(in: &subscription)
        
    }
    
    //MARK: - Fetch Methods
        func fetchProducts(for categoryID: Int?) {
            Task {
                let result = await networkService.fetchProducts(with: categoryID)
                switch result {
                case .success(let products):
                    self.products = products
                case .failure(let error):
                    print("Error fetching products: \(error)")
                }
            }
        }
    
    func fetchSearchProducts(_ searchText: String) {
        Task {
            let result = await networkService.fetchSearchProducts(searchText)
            switch result {
            case .success(let products):
                self.products = products
            case .failure(let error):
                print("Failed to fetch products: \(error)")
            }
        }
    }
    
    func fetchCategory() {
        Task {
            let result = await networkService.fetchAllCategories()
            switch result {
            case .success(let categories):
                self.categories = categories
            case .failure(let error):
                print("Error fetching products: \(error)")
            }
        }
    }
    
    //MARK: - Storage Methods
    func addToCarts(product: Products) {
        storageService.addItem(CartsModel.self, product) { result in
            switch result {
            case .success:
                print("Item added from cart successfully")
            case .failure(let error):
                print("Error adding product to cart: \(error)")
            }
        }
    }
}
