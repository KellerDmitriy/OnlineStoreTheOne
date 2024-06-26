//
//  HomeViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 19.04.2024.
//

import UIKit
import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var productsError: Error?
    @Published var categoriesError: Error?
    
    @Published var productCount = 1
    
    @Published var isLoading: Bool = true
    @Published var categories: [Category] = []
    @Published var products: [Products] = []
    @Published var searchedProducts: [Products] = []
    @Published var searchText = ""
    
    @Published var selectedCategory: Int = 1
    
    var subscription: Set<AnyCancellable> = []
    
    let networkService = NetworkService.shared
    let storageService = RealmStorageService.shared
    
    //MARK: - Init
    init() {
        observe()
    }
    
    //MARK: - Observe Methods
    private func observe() {
        $searchText
            .sink {  searchText in
            }
            .store(in: &subscription)
        
        $selectedCategory
            .sink { [weak self] categoryId in
                self?.fetchProducts(for: categoryId)
            }
            .store(in: &subscription)
    }
    
    //MARK: - Fetch Methods
    func updateCategory(_ id: Int) {
        selectedCategory = id
    }
    
    func fetchProducts(for categoryID: Int?) {
        Task {
            let result = await networkService.fetchProducts(with: categoryID)
            switch result {
            case .success(let products):
                self.isLoading = false
                self.products = products
            case .failure(let error):
                self.productsError = error
            }
        }
    }
    
    
    func fetchCategory() {
        Task {
            let result = await networkService.fetchAllCategories()
            switch result {
            case .success(let categories):
                let filteredCategories = filterCategories(categories)
                let uniqueCategories = filterUniqueCategories(filteredCategories)
                self.categories = uniqueCategories
            case .failure(let error):
                self.categoriesError = error
            }
        }
    }
    
    //MARK: - Storage Methods
    
    func getProductsFromCart() {
        let cart = storageService.getCartFromRealm()
        let productCount = cart.count
    }
    
    func addToCarts(product: Products) {
        storageService.addProductToCart(product) { result in
            switch result {
            case .success:
                print("Item added from cart successfully")
            case .failure(let error):
                print("Error adding product to cart: \(error)")
            }
        }
    }
}

//MARK: - Helper Methods
extension HomeViewModel {
    func filterCategories(_ categories: [Category]) -> [Category] {
        return categories.filter { category in
            if let name = category.name, let imageURL = category.image, name != "New Category" {
                return name.count <= 15
            }
            return false
        }
    }

    func filterUniqueCategories(_ categories: [Category]) -> [Category] {
        var uniqueCategories: [Category] = []
        var seenNames: Set<String> = Set()
        for category in categories {
            if let name = category.name, !seenNames.contains(name) {
                uniqueCategories.append(category)
                seenNames.insert(name)
            }
        }
        return uniqueCategories
    }
}

