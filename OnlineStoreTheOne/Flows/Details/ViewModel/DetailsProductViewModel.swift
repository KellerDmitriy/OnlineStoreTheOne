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
    
    var cancellables: Set<AnyCancellable> = []
    
    weak var coordinator: IDetailCoordinator?
    let networkService: NetworkServiceProtocol
    let storageService: StorageServiceProtocol
    
    // MARK: - Init
    init(productId: Int, coordinator: IDetailCoordinator) {
        self.coordinator = coordinator
        self.networkService = DIService.resolve(forKey: DIKey.networkService) ?? NetworkService()
        self.storageService = DIService.resolve(forKey: DIKey.storageService) ?? StorageService()
        
        self.isSaved = storageService.isWishListSaved(productId)
        
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
    func addToCart() {
       let cartItem = CartModel(product: product, countProduct: 1, isSelected: true)
        storageService.saveOrUpdateCart(cartItem)
    }
    
    func addToWishList() {
        storageService.addIDsForWishList(product.id)
    }
    
    func removeFromWishList() {
        storageService.removeIDFromWishList(product.id)

    }
    
    //    MARK: - Route
    func showCartFLow() {
        coordinator?.showCartsFlow()
    }
    
    func showPayScene() {
        coordinator?.showPayScene()
    }
    
    func dismissScreen() {
        coordinator?.popViewController()
    }
}
