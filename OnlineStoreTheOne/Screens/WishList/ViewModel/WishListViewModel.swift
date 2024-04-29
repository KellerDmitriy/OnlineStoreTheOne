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
    let storageService = StorageService.shared
    let realmStorageService = RealmStorageService.shared
    
    @Published var wishList: [Products] = []
    var filteredWishList: [Products] = []
    @Published var wishListKeys: [Int] = []
    var subscription: Set<AnyCancellable> = []
    
    init() {
        getWishListIDs()
        observeProducts()
    }
    
    private func observeProducts() {
        $wishListKeys
            .receive(on: DispatchQueue.main)
            .sink { [weak self] wishListKeys in
                wishListKeys.forEach { id in
                    self?.fetchProducts(wishListKey: id)
                }
            }
            .store(in: &subscription)
    }
    
    func fetchProducts(wishListKey: Int) {
        wishList = []
        Task {
            let result = await self.networkService.fetchSingleProduct(for: wishListKey)
            switch result {
            case .success(let product):
                self.wishList.append(product)
            case .failure(let error):
                print("Error fetching product: \(error)")
            }
        }
    }
    
    
    func getWishListIDs() {
        wishListKeys = storageService.getWishListIDs()
    }
    
    func removeWishList(at id: Int) {
        storageService.deleteWishListID(id)
        wishList.removeAll { $0.id == id }
    }
    
    //MARK: - Storage Methods
    func addToCart(_ product: Products) {
        realmStorageService.addItem(CartsModel.self, product) { result in
            switch result {
            case .success:
                print("Item added from WishList successfully")
            case .failure(let error):
                print("Error adding/removing item from wishlist: \(error)")
            }
        }
    }
    
}
