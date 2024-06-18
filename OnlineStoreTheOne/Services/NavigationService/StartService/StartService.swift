//
//  StartService.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 09.05.2024.
//

import Foundation

enum TypeOfAccount: String {
    case manager = "Manager"
    case user = "User"
}

final class Context {
    var authService: IFirebase = DIService.resolve(forKey: .authService) ?? FirebaseService()
    var storageService: StorageServiceProtocol = DIService.resolve(forKey: .storageService) ?? StorageService()
    
    var isOnboardComplete: Bool {
        get { return storageService.isOnboardComplete }
        set { storageService.isOnboardComplete = newValue }
    }
    
    lazy var isAuth: () -> Bool = { [weak self] in
       self?.authService.isAuthenticated() ?? false
    
    }
}

protocol IStartService {
    func selectStartFlow(context: Context) -> CoordinatorType
}

final class StartService: IStartService {
    func selectStartFlow(context: Context) -> CoordinatorType {
        if !context.isOnboardComplete {
            return .onboarding
        } else if context.isAuth() {
            return .tabBar
        } else {
            return .auth
        }
    }
}
