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
    //MARK:  Properties
    let networkService = NetworkService.shared
    let storageService = RealmStorageService.shared
    
    @Published var wishLists: Results<WishListModel>!
    var product = Products.placeholder
    var filteredWishLists: Results<WishListModel>?
    var subscription: Set<AnyCancellable> = []
    
    //MARK: - Init
    init() {
        wishLists = storageService.realm.objects(WishListModel.self)
    }
    
    //MARK: - Methods
    
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
    
    func convertToProducts(from wishList: WishListModel) -> Products {
        let product = Products(
            id: wishList.id,
            title: wishList.title,
            price: wishList.price,
            description: nil,
            category: nil,
            image: nil,
            images: wishList.images.map { $0.base64EncodedString() }
        )
        return product
    }
    
    func removeWishList(at id: Int, completion: @escaping () -> Void) {
        storageService.removeItem(WishListModel.self, id: id) { result in
            switch result {
            case .success:
                print("Item removed from cart")
                DispatchQueue.main.async {
                    self.wishLists = self.storageService.realm.objects(WishListModel.self)
                    completion()
                }
            case .failure(let error):
                print("Error removing item from cart: \(error)")
            }
        }
    }
}

