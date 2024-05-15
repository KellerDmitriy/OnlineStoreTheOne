//
//  StartEntity.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 09.05.2024.
//

import Foundation

enum Flow {
    case onboarding
    case auth
    case tabBar
}

enum TypeOfAccount: String {
    case manager = "Manager"
    case basic = "Basic"
}

final class Context {
    var authService: IFirebase = DIService.resolve(forKey: .authService) ?? FirebaseService()
    var storageService: StorageServiceProtocol = DIService.resolve(forKey: .storageService) ?? StorageService()
    
    var isOnboardComplete: Bool {
        get { return storageService.isOnboardComplete }
        set { storageService.isOnboardComplete = newValue }
    }
    
    lazy var isAuth: () -> Bool = { [weak self] in
//       self?.authService.isAuthenticated() ?? false
        true
    }
}

protocol IStartEntity {
    func selectStartFlow(context: Context) -> Flow
}

final class StartEntity: IStartEntity {
    func selectStartFlow(context: Context) -> Flow {
        if !context.isOnboardComplete {
            return .onboarding
        } else if context.isAuth() {
            return .tabBar
        } else {
            return .auth
        }
    }
}
