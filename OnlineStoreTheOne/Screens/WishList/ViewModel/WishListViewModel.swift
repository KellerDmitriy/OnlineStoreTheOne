//
//  WishListViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 16.04.2024.
//

import Foundation
import RealmSwift

final class WishListViewModel {
    //MARK:  Properties
    let networkService = NetworkService.shared
    let storageService = RealmStorageService.shared
    
    var wishListKeys: Observable<[Int]> = Observable([])
    var products: Observable<[Products]> = Observable([])
    
    var filteredWishLists: Observable<[WishListModel]> = Observable([])
    
    //MARK: - Init
    init() {
        wishListKeys.value = storageService.realm.objects(WishListModel.self).map { $0.id }
    }
    
    private func observeProducts() {
        wishListKeys.bind { [weak self] _ in
            guard let self = self else { return }
            self.fetchProducts()
        }
    }
    
    func fetchProducts() {
        for wishListKey in self.wishListKeys.value {
            Task {
                let result = await self.networkService.fetchSingleProduct(for: wishListKey)
                switch result {
                case .success(let product):
                    DispatchQueue.main.async {
                        self.products.value.append(product)
                    }
                case .failure(let error):
                    print("Error fetching product: \(error)")
                }
            }
        }
    }
    
    //MARK: - Storage Methods
    func addToCart(_ product: Products) {
        storageService.addItem(CartsModel.self, product) { result in
            switch result {
            case .success:
                print("Item added from WishList successfully")
            case .failure(let error):
                print("Error adding/removing item from wishlist: \(error)")
            }
        }
    }
    
    
    //MARK: - Storage Methods
    func removeWishList(at id: Int, completion: @escaping () -> Void) {
        storageService.removeItem(WishListModel.self, id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                print("Item removed from WishList")
                self.wishListKeys.value = self.storageService.realm.objects(WishListModel.self).map { $0.id }
                if let index = self.products.value.firstIndex(where: { $0.id == id }) {
                       self.products.value.remove(at: index)
                   }
                completion()
            case .failure(let error):
                print("Error removing item from cart: \(error)")
            }
        }
    }
}
