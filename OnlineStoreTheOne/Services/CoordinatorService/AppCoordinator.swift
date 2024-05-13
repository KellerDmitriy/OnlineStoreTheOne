//
//  AppCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 09.05.2024.
//

import UIKit

final class AppCoordinator: IAppCoordinator {
    
    // MARK: - Properties
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    let networkService: NetworkServiceProtocol
    let storageService: StorageServiceProtocol
    
    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
      
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
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    func showTabBarFlow() {
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            networkService: networkService,
            storageService: storageService
        )
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
    func showAlertController(title: String, message: String, createAction: @escaping (String) -> Void) {
        let alert = UIAlertFactory.createAlert(title: title, message: message, completion: createAction)
        navigationController.present(alert, animated: true, completion: nil)
    }
}
