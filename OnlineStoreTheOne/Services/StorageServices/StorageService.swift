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
        static let savedSearchText = "SavedSearchText"
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
    
    // MARK: - SavedSearchText
    func saveSearchText() {
        userDefaults.set(true, forKey: UserDefaultKeys.savedSearchText)
    }
    
    func addSearchedText() -> String {
        userDefaults.object(forKey: UserDefaultKeys.savedSearchText) as! String
    }
}
