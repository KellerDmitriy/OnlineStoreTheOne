//
//  DetailsProductViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 21.04.2024.
//

import Foundation
import Combine

final class DetailsProductViewModel: ObservableObject {
    // MARK: - Properties
    @Published var product = Products.placeholder
    @Published var isSaved: Bool
    //    @Published var isCart: Bool
    
    var cancellables: Set<AnyCancellable> = []
    
    let networkService = NetworkService.shared
    
    let storageService = StorageService.shared
    
    // MARK: - Init
    init(productId: Int) {
        self.isSaved = storageService.isItemSaved(productId)
        //        self.isCart = storageService.isItemSaved(CartsModel.self, id: productId)
        
        fetchProductDetails(productId: productId)
    }
    
    func favoriteButtonPressed() {
        isSaved.toggle()
        
        isSaved
        ? addToWishList()
        : removeFromWishList()
    }
    
    
    // MARK: -  Fetch Methods
    private func fetchProductDetails(productId: Int) {
        Task {
            let result = await networkService.fetchSingleProduct(for: productId)
            switch result {
            case .success(let model):
                self.product = model
            case .failure(let error):
                print("Error fetching products: \(error)")
            }
        }
    }
    
    //MARK: - Storage Methods
    //    func addToCart() {
    //        storageService.addItem(CartsModel.self, product) { result in
    //            switch result {
    //            case .success:
    //                print("Item added from cart successfully")
    //            case .failure(let error):
    //                print("Error adding/removing item from wishlist: \(error)")
    //            }
    //        }
    //    }
    
    func addToWishList() {
        storageService.saveWishListID(id: product.id)
    }
    
    func removeFromWishList() {
        storageService.deleteWishListID(product.id)
        
    }
}
