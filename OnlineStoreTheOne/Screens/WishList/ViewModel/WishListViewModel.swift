//
//  WishListViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 16.04.2024.
//

import Foundation
import Combine
import RealmSwift

final class WishListViewModel {
    let networkService = NetworkService.shared
//    let storageService = StorageService.shared
    let realmStorageService = RealmStorageService.shared
    
    @Published var wishList: [Products] = []
    @Published var filteredWishList: [Products] = []
    
    @Published var wishListKeys: Results<WishListModel>!
    
    var subscription: Set<AnyCancellable> = []
    
    init() {
        observeProducts()
    }
    
    private func observeProducts() {
        $wishListKeys
            .sink { [weak self] wishListKeys in
                wishListKeys?.forEach { wishList in
                    self?.fetchProducts(wishListKey: wishList.id)
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
    
    func getWishListIDs() {
        wishListKeys = realmStorageService.getWishListFromRealm()
    }
    
    func removeWishList(at id: Int) {
        realmStorageService.removeItem(WishListModel.self, id: id) { result in
            switch result {
            case .success:
                print("Item removed from cart")
            case .failure(let error):
                print("Error removing item from cart: \(error)")
            }
        }
        wishList.removeAll { $0.id == id }
    }
}
