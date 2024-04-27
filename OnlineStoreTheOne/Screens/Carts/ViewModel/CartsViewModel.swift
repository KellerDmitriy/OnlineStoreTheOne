//
//  CartsViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//

import Foundation
import Combine
import RealmSwift

final class CartsViewModel {
    //MARK:  Properties
    let networkService = NetworkService.shared
    let storageService = RealmStorageService.shared
    
    @Published var cartProducts: Results<CartsModel>!
    
    var subscription: Set<AnyCancellable> = []
    
    //MARK: - Init
    init() {
        cartProducts = storageService.realm.objects(CartsModel.self)
    }
    
    //MARK: - Methods
    
    func removeFromCart(_ id: Int) {
        storageService.removeItem(CartsModel.self, id: id) { result in
            switch result {
            case .success:
                print("Item removed from cart")
            case .failure(let error):
                print("Error removing item from cart: \(error)")
            }
        }
    }
    
    func incrementCountProduct(for id: Int) {
        guard let cartProduct = cartProducts.first(where: { $0.id == id }) else { return }
        let newCount = cartProduct.countProduct + 1
        storageService.updateItem(CartsModel.self, id: id) { item in
            item?.countProduct = newCount
        }
    }
    
    func decrementCountProduct(for id: Int) {
        guard let cartProduct = cartProducts.first(where: { $0.id == id }) else { return }
        let newCount = max(cartProduct.countProduct - 1, 0)
        storageService.updateItem(CartsModel.self, id: id) { item in
            item?.countProduct = newCount
        }
    }
    
    func deleteAllProducts() {
         storageService.deleteCarts()
     }
}
