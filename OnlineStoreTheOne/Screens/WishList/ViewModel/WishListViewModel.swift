//
//  WishListViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 16.04.2024.
//

import Foundation
import Combine

final class WishListViewModel {
    let networkService = NetworkService.shared
    
    @Published var wishLists: [Products] = []
    var filteredWishLists: [Products] = []
    
    var subscription: Set<AnyCancellable> = []
    
    init() {
        
    }
    
    public func getData(id: Int) {
        Task {
            let result = await networkService.fetchProducts(for: id)
            switch result {
            case .success(let products):
                self.wishLists = [products]
            case .failure(let error):
                print("Error fetching products: \(error)")
                
            }
        }
    }
}
