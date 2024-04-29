//
//  StorageService.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 18.04.2024.
//

import Foundation

final class StorageService {
    // MARK: - Properties
    public static let shared = StorageService()
    private let userDefaults = UserDefaults.standard
    
    enum UserDefaultKeys {
        static let onboardCompleted = "OnboardCompleted"
        static let searchText = "SavedSearchText"
        static let wishListID = "SavedWishListID"
    }
    
    // MARK: - Initialization
    private init () {}
    
    // MARK: - Onboarding
    func onboardCompleted() {
        userDefaults.set(true, forKey: UserDefaultKeys.onboardCompleted)
    }
    
    func isOnboardComplete() -> Bool {
        userDefaults.bool(forKey: UserDefaultKeys.onboardCompleted)
    }
    
    func onboardingOn() {
        userDefaults.set(false, forKey: UserDefaultKeys.onboardCompleted)
    }
    
    // MARK: - SavedWishListID
    func saveWishListID(id: Int) {
        var wishListIDs = getWishListIDs()
        if !wishListIDs.contains(id) {
            wishListIDs.append(id)
            userDefaults.set(wishListIDs, forKey: UserDefaultKeys.wishListID)
        }
    }
    
    func isItemSaved(_ id: Int) -> Bool {
        let wishListIds = userDefaults.array(forKey: UserDefaultKeys.wishListID) as? [Int] ?? []
        return wishListIds.contains(id)
    }
    
    func deleteWishListID(_ id: Int) {
        var wishListIDs = getWishListIDs()
        if let index = wishListIDs.firstIndex(of: id) {
            wishListIDs.remove(at: index)
            userDefaults.set(wishListIDs, forKey: UserDefaultKeys.wishListID)
        }
    }

    func getWishListIDs() -> [Int] {
        if let wishListIDs = userDefaults.object(forKey: UserDefaultKeys.wishListID) as? [Int] {
            return wishListIDs
        } else {
            return []
        }
    }
    
    // MARK: - SavedSearchText
    func saveSearchText() {
        userDefaults.set(true, forKey: UserDefaultKeys.searchText)
    }
    
    func getSearchedText() -> [String] {
        if let savedSearchTexts = userDefaults.object(forKey: UserDefaultKeys.searchText) as? [String] {
            return savedSearchTexts
        } else {
            return []
        }
    }
}
