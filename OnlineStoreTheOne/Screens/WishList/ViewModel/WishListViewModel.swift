//
//  WishListViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 16.04.2024.
//

import Foundation
import Combine

final class WishListViewModel {
    //MARK:  Properties
    let networkService = NetworkService.shared
    let storageService = StorageService.shared
    
    @Published var wishLists: [Products] = []
    
    var filteredWishLists: [Products] = []
    
    var savedWishListIDs: [Int] = []
    
    var subscription: Set<AnyCancellable> = []
    
    //MARK: - Init
    init() {
        savedWishListIDs = storageService.getWishListIDs()
//        savedWishListIDs.forEach { id in
//            fetchData(for: id)
//        }
    }
    

    
    //MARK: - Methods
    func fetchData(for id: Int) {
        Task {
            let result = await networkService.fetchProducts(for: id)
            switch result {
            case .success(let products):
                self.wishLists.append(products)
            case .failure(let error):
                print("Error fetching products: \(error)")
                
            }
        }
    }
    
    func removeWishList(at id: Int) {
        wishLists.remove(at: id)
        storageService.deleteWishListID(id: id)
    }
    
}
