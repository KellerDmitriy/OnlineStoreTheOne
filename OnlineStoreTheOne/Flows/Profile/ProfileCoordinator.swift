//
//  ProfileCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//

import UIKit

final class ProfileCoordinator: IProfileCoordinator {
    
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    let storageService: StorageServiceProtocol
    
    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.storageService = DIService.resolve(forKey: .storageService) ?? StorageService()
    }
    
    // MARK: - Coordinator Lifecycle
    func start(_ flow: Flow? = nil) {
        showProfileScene()
    }
    
    // MARK: - Flow Presentation
    func showProfileScene() {
        let viewModel = ProfileViewModel(storageService: storageService)
        let viewController = ProfileViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showTypeOfAccountScene() {
        let viewController = TypeAccountViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showTermAndConditionScene() {
        let viewController = TermsConditionalViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showOnboardingFlow() {
        let coordinator = OnboardingCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
