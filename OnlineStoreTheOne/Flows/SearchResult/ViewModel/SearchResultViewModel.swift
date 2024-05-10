//
//  SearchResultViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 26.04.2024.
//

import Foundation
import Combine

final class SearchResultViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var productsError: Error?
    
    @Published var products: [Products] = []
    @Published var searchedProducts: [Products] = []
    
    @Published var searchText = ""
    @Published var savedSearchText = [String]()
    var subscription: Set<AnyCancellable> = []
    
    let networkService: NetworkServiceProtocol
    let storageService: StorageServiceProtocol
    
    //MARK: - Init
    init(searchText: String, networkService: NetworkServiceProtocol, storageService: StorageServiceProtocol) {
        self.networkService = networkService
        self.storageService = storageService
        
        self.searchText = searchText
        if !searchText.isEmpty {
            fetchProducts()
        }
        observe()
    }

    //MARK: - Observe Methods
    private func observe() {
        $searchText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.fetchProducts()
            }
            .store(in: &subscription)
    }
    
    //MARK: - Fetch Methods
    func fetchProducts() {
        Task {
            let result = await networkService.fetchAllProducts()
            switch result {
            case .success(let products):
                self.isLoading = false
                self.products = products
            case .failure(let error):
                print(error)
                self.productsError = error
            }
        }
    }
    
    //MARK: - Storage Methods
    
    func addToCart(_ productId: Int) {
        if let product = products.first(where: { $0.id == productId }) {
            let cartItem = CartModel(product: product, countProduct: 1, isSelected: true)
            
            storageService.saveOrUpdateCart(cartItem)
        }
    }
    
//    MARK: - Saved Search Text
    
    func saveSearchText(_ text: String) {
        storageService.saveSearchText(text)
    }
    
    func getSearchText() {
        savedSearchText = storageService.getSearchedText()
    }
}
