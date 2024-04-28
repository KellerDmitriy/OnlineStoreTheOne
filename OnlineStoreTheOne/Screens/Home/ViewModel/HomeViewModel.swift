//
//  HomeViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 19.04.2024.
//


import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published var isLoading: Bool = true
    @Published var categories: [Category] = []
    @Published var products: [Products] = []
    @Published var searchedProducts: [Products] = []
    @Published var searchText = ""
    
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
    }
    
    //MARK: - Fetch Methods
    func fetchData() {
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { [weak self] in
                     self?.fetchProducts(for: nil)
                }
                group.addTask { [weak self] in
                     self?.fetchCategory()
                }
                
                await group.waitForAll()
                self.isLoading = false
            }
        }
    }
    
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
