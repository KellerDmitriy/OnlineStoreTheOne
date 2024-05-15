//
//  AppCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 09.05.2024.
//

import UIKit

final class AppCoordinator: IAppCoordinator, ICoordinatorFinishDelete {
    
    // MARK: - Properties
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    let context: Context
    let networkService: NetworkServiceProtocol
    let storageService: StorageServiceProtocol
    
    // MARK: - Initialization
    init(navigationController: UINavigationController, context: Context) {
        self.navigationController = navigationController
        self.context = context
        self.networkService = DIService.resolve(forKey: .networkService) ?? NetworkService()
        self.storageService = DIService.resolve(forKey: .storageService) ?? StorageService()
    }
    
    // MARK: - Coordinator Lifecycle
    func start(_ flow: Flow? = nil) {
        switch flow {
        case .onboarding:
            showOnboardingFlow()
        case .auth:
            showAuthFlow()
        case .tabBar:
            showTabBarFlow()
        case .none:
            showAuthFlow()
        }
    }
    
    // MARK: - Flow Presentation
    func showOnboardingFlow() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator.finishDelegate = self
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.finishDelegate = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    func showTabBarFlow() {
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
//    MARK: - Helpers Methods
    func didFinish(_ coordinator: ICoordinator) {
           childCoordinators = childCoordinators.filter { $0 !== coordinator }
           
           switch coordinator {
           case is OnboardingCoordinator:
               context.isOnboardComplete = true
               start(.auth)
           case is AuthCoordinator:
               start(.tabBar)
           default:
               break
           }
       }
}
