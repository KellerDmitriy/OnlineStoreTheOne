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
    
    @Published var isSelect = true
    @Published var productCount = 1
    
    var subscription: Set<AnyCancellable> = []
    
    //MARK: - Init
    init() {
    
    }
    
    //MARK: - Observe Methods
   
    
    //MARK: - Storage Methods
    func updateItemCount(for id: Int, newCount: Int) {
        updateItem(for: id, newValue: newCount)
    }
    
    func checkSelected(for id: Int) {
        isSelect.toggle()
        guard cartProducts.first(where: { $0.id == id }) != nil else { return }
        updateItem(for: id, newValue: isSelect)
    }
    
    func getProductsFromCart() {
        cartProducts = storageService.getCartFromRealm()
    }
    
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
    
    func deleteAllProducts() {
        storageService.deleteAllProducts(CartsModel.self)
    }
    

    
    //MARK: - Helper Methods
    func updateItem<T>(for id: Int, newValue: T) {
        storageService.updateItem(CartsModel.self, id: id) { item in
            if let item = item {
                if let newValue = newValue as? Int {
                    item.countProduct = newValue
                } else if let newValue = newValue as? Bool {
                    item.isSelected = newValue
                }
            }
        }
    }
}
