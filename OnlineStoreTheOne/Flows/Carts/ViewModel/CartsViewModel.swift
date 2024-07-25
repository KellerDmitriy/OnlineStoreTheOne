//
//  CartsViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//

import Foundation
import Combine

final class CartsViewModel: ObservableObject {
    //MARK:  Properties
    let storageService: StorageServiceProtocol
    let coordinator: ICartsCoordinator
    
    @Published var cartProducts: [CartModel] = []
    
    @Published var isSelect = true
    @Published var productCount = 1
    @Published var orderSummary = 0
    
    var subscription: Set<AnyCancellable> = []
    
    //MARK: - Init
    init(coordinator: ICartsCoordinator, storageService: StorageServiceProtocol) {
        self.coordinator = coordinator
        self.storageService = storageService
        
        observeCartProducts()
        getProductsFromCart()
    }
    
    //MARK: - Observe Methods
    private func observeCartProducts() {
        $isSelect
            .receive(on: DispatchQueue.main)
            .sink { [weak self] carts in
                self?.getOrderSummery()
            }
            .store(in: &subscription)
        
        $productCount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] carts in
                self?.getOrderSummery()
            }
            .store(in: &subscription)
    }
    
    //MARK: - Public Methods
    func updateProductCount(for id: Int, newCount: Int) {
        productCount = newCount
        storageService.updateCart(for: id, newValue: newCount)
    }
    
    func updateCheckMark(for id: Int, isSelect: Bool) {
        guard cartProducts.first(where: { $0.product.id == id }) != nil else { return }
        self.isSelect = isSelect
        storageService.updateCart(for: id, newValue: isSelect)
    }
    
    func getProductsFromCart() {
        cartProducts = storageService.getCarts()
    }
    
    func removeFromCart(_ id: Int) {
        storageService.removeCartItem(for: id)
        getProductsFromCart()
    }
    
    //MARK: - Helper Methods
    func getOrderSummery() {
        orderSummary = 0
        for cart in cartProducts {
            if cart.isSelected {
                orderSummary += cart.product.price * cart.countProduct
            }
        }
    }
    
    //    MARK: - Route
    func showPayFlow() {
        coordinator.showPayScene()
    }
    
    func showCartsScene() {
        coordinator.showCartsScene()
    }
    
    func dismissCartsScene() {
        coordinator.popViewController()
    }
}
