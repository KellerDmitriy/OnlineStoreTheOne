//
//  DetailsProductViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 21.04.2024.
//

import Foundation
import Combine

final class DetailsProductViewModel: ObservableObject {
    @Published var product = Products.placeholder
    
    var cancellables: Set<AnyCancellable> = []
    let storageService = RealmStorageService.shared
    
    init(productId: Int) {
        fetchProductDetails(productId: productId)
    }
    
    private func fetchProductDetails(productId: Int) {
        Task {
            let result = await NetworkService.shared.fetchSingleProduct(for: productId)
            switch result {
            case .success(let model):
                self.product = model
            case .failure(let error):
                print("Error fetching products: \(error)")
            }
        }
    }
    
    //MARK: - Storage Methods
    func addToCart() {
        storageService.addItem(CartsModel.self, product) { result in
            switch result {
            case .success:
                print("Item added from cart successfully")
            case .failure(let error):
                print("Error adding/removing item from wishlist: \(error)")
            }
        }
    }
}
