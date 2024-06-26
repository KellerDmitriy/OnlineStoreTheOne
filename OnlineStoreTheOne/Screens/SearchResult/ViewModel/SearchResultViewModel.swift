//
//  SearchResultViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 26.04.2024.
//

import Foundation
import Combine

final class SearchResultViewModel: ObservableObject {
    
    @Published var searchedProducts: [Products] = []
    @Published var searchText = ""
    
    var subscription: Set<AnyCancellable> = []
    
    let networkService = NetworkService.shared
    let storageService = RealmStorageService.shared
    
//    //MARK: - Init
//    init() {
//        observe()
//    }
//    
//    //MARK: - Observe Methods
//    private func observe() {
//        $searchText
//            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
//            .removeDuplicates()
//            .sink { [weak self] searchText in
//                self?.fetchSearchProducts(searchText)
//            }
//            .store(in: &subscription)
//    }
    
    //MARK: - Fetch Methods
    func fetchSearchProducts(_ searchText: String) {
        Task {
            let result = await networkService.fetchSearchProducts(searchText)
            switch result {
            case .success(let products):
              
                self.searchedProducts = products
            case .failure(let error):
                print("Failed to fetch products: \(error)")
            }
        }
    }
    
    //MARK: - Storage Methods
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
