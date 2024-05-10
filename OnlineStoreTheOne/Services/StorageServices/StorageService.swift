//
//  StorageService.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 18.04.2024.
//

import Foundation

protocol StorageServiceProtocol {
    var isOnboardComplete: Bool { get set }

    func onboardingOn()
    func saveSearchText(_ text: String)
    func getSearchedText() -> [String]
    func addIDsForWishList(_ id: Int)
    func getIDsForWishList() -> [Int]?
    func removeIDFromWishList(_ id: Int)
    func isWishListSaved(_ id: Int) -> Bool
    func addCarts(_ cartItems: [CartModel])
    func saveOrUpdateCart(_ cartItem: CartModel)
    func getCarts() -> [CartModel]
    func updateCart<T>(for id: Int, newValue: T)
    func removeCartItem(for id: Int)
}

final class StorageService: StorageServiceProtocol {
    // MARK: - Properties

    private let userDefaults = UserDefaults.standard
    
    enum UDKeys {
        static let authCompleted = "authCompleted"
        static let onboardCompleted = "OnboardCompleted"
        static let searchText = "SavedSearchText"
        static let wishListIDs = "wishListIDs"
        static let cartKey = "cartKey"
    }
    
    // MARK: - Initialization
    init() {}
    
    // MARK: - Auth
    func isAuthComplete() -> Bool {
        userDefaults.bool(forKey: UDKeys.authCompleted)
    }
    
    // MARK: - Onboarding
    
    var isOnboardComplete: Bool {
        get {
            userDefaults.bool(forKey: UDKeys.onboardCompleted)
        }
        set {
            userDefaults.set(newValue, forKey: UDKeys.onboardCompleted)
        }
    }
    
    func onboardingOn() {
        userDefaults.set(false, forKey: UDKeys.onboardCompleted)
    }
    
    
    // MARK: - SavedSearchText
    func saveSearchText(_ text: String) {
        userDefaults.set(text, forKey: UDKeys.searchText)
    }
    
    func getSearchedText() -> [String] {
        if let savedSearchTexts = userDefaults.object(forKey: UDKeys.searchText) as? [String] {
            return savedSearchTexts
        } else {
            return []
        }
    }
    
    // MARK: - saved ID for WishList
    func addIDsForWishList(_ id: Int) {
        var wishListIDs = userDefaults.array(forKey: UDKeys.wishListIDs) as? [Int] ?? []
        if !wishListIDs.contains(id) {
            wishListIDs.append(id)
            userDefaults.set(wishListIDs, forKey: UDKeys.wishListIDs)
        }
    }
    
    func getIDsForWishList() -> [Int]? {
        if let savedIDs = userDefaults.object(forKey: UDKeys.wishListIDs) as? [Int] {
            return savedIDs
        } else {
            return []
        }
    }
    
    func removeIDFromWishList(_ id: Int) {
        if var savedIDs = getIDsForWishList(),
           let index = savedIDs.firstIndex(of: id) {
            savedIDs.remove(at: index)
            userDefaults.set(savedIDs, forKey: UDKeys.wishListIDs)
        }
    }
    
    func isWishListSaved(_ id: Int) -> Bool {
        let wishListIDs = userDefaults.array(forKey: UDKeys.wishListIDs) as? [Int] ?? []
        return wishListIDs.contains(id)
    }
    
    // MARK: - saved for Carts
    func addCarts(_ cartItems: [CartModel]) {
           let cartItemsData = try? JSONEncoder().encode(cartItems)
        userDefaults.set(cartItemsData, forKey: UDKeys.cartKey)
       }
    
    func saveOrUpdateCart(_ cartItem: CartModel) {
        var cartItems = getCarts()
        if let index = cartItems
            .firstIndex(where: { $0.product.id == cartItem.product.id }) {
            cartItems[index].countProduct += 1
            cartItems[index].isSelected = cartItem.isSelected
        } else {
            cartItems.append(cartItem)
        }
        addCarts(cartItems)
    }
    
    func getCarts() -> [CartModel] {
           guard let cartItemsData = userDefaults.data(forKey: UDKeys.cartKey),
                 let decodedCartItems = try? JSONDecoder().decode([CartModel].self, from: cartItemsData) else {
               return []
           }
           return decodedCartItems
       }
    
    func updateCart<T>(for id: Int, newValue: T) {
        var cartItems = getCarts()
        
        guard let index = cartItems.firstIndex(where: { $0.product.id == id }) else {
            return
        }
        
        if let newValue = newValue as? Int {
            cartItems[index].countProduct = newValue
        } else if let newValue = newValue as? Bool {
            cartItems[index].isSelected = newValue
        }
        
        addCarts(cartItems)
    }
    
    func removeCartItem(for id: Int) {
        var cartItems = getCarts()
        
        if let index = cartItems.firstIndex(where: { $0.product.id == id }) {
            cartItems.remove(at: index)
            addCarts(cartItems)
        }
    }

}

