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
    private let networkService: NetworkServiceProtocol
    private let storageService: StorageServiceProtocol
    private let coordinator: IWishListCoordinator
    
    @Published var wishList: [Products] = []
    @Published var filteredWishList: [Products] = []
    
    @Published var wishListKeys: [Int] = []
    
    var subscription: Set<AnyCancellable> = []
    
    //MARK: - Init
    init(networkService: NetworkServiceProtocol, storageService: StorageServiceProtocol, coordinator: IWishListCoordinator) {
        self.networkService = networkService
        self.storageService = storageService
        self.coordinator = coordinator
        observeProducts()
    }
    
    //MARK: - Observe Methods
    private func observeProducts() {
        $wishListKeys
            .sink { [weak self] wishListKeys in
                wishListKeys.forEach { id in
                    self?.fetchProducts(wishListKey: id)
                }
            }
            .store(in: &subscription)
    }
    
    //MARK: - Fetch Methods
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
    func addToCart(_ productId: Int) {
        if let product = wishList.first(where: { $0.id == productId }) {
            let cartItem = CartModel(product: product, countProduct: 1, isSelected: true)
            
            storageService.saveOrUpdateCart(cartItem)
        }
    }
    
    func getWishListIDs() {
        wishListKeys = storageService.getIDsForWishList() ?? []
    }
    
    func removeWishList(at id: Int) {
        storageService.removeIDFromWishList(id)
        wishList.removeAll { $0.id == id }
    }
    
    //    MARK: - Route
    func showCartsFlow() {
        coordinator.showCartsFlow()
    }
    
    func coordinatorFinish() {
        coordinator.finish()
    }
    
    func showDetailFlow(_ id: Int) {
        coordinator.showDetailFlow(id)
    }
}
