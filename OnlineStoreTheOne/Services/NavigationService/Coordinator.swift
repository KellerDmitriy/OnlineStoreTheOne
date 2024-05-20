//
//  Coordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 20.05.2024.
//

import UIKit

class Coordinator: ICoordinator, ICoordinatorFinishDelete {
    let flow: Flow
    
    // MARK: - Properties
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    let networkService: NetworkServiceProtocol
    let storageService: StorageServiceProtocol
    
    // MARK: - Initialization
    init(flow: Flow, navigationController: UINavigationController) {
        self.flow = flow
        self.navigationController = navigationController
        self.networkService = DIService.resolve(forKey: .networkService) ?? NetworkService()
        self.storageService = DIService.resolve(forKey: .storageService) ?? StorageService()
    }
    
    deinit {
        childCoordinators.forEach { $0.finishDelegate = nil }
        childCoordinators.removeAll()
    }
    
    // MARK: - Coordinator Lifecycle
    func start() {
//        switch flow {
//        case .onboarding:
//            showOnboardingFlow()
//        case .auth:
//            showAuthFlow()
//        case .tabBar:
//            showTabBarFlow()
//        case .none:
//            showAuthFlow()
//        }
    }
    
    func finish() {
        
    }
    
//    MARK: - Helpers Methods
    func didFinish(_ coordinator: ICoordinator) {
        removeChildCoordinator(coordinator)
        switch coordinator.flow {
            
        case .app:
         return finish()
        case .onboarding:
            return finish()
        case .auth:
            return finish()
        case .tabBar:
            return finish()
        case .home:
            return finish()
        case .wishList:
            return finish()
        case .detail:
            return finish()
        case .carts:
            return finish()
        case .manager:
            return finish()
        case .profile:
            return finish()
        }
    }
}

