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

final class Context {
    private let storageService = StorageService()
    
    var isOnboardComplete: Bool {
        get { return self.storageService.isOnboardComplete }
        set { storageService.isOnboardComplete = newValue }
    }
    
    lazy var isAuth: () -> Bool = {
//        TODO: -
        return false
    }
}

protocol IStartEntity {
    func selectStartFlow(context: Context) -> Flow
}

final class StartEntity: IStartEntity {
    func selectStartFlow(context: Context) -> Flow {
        if context.isOnboardComplete {
            return .onboarding
        } else if context.isAuth() {
            return .tabBar
        } else {
            return .auth
        }
    }
}
