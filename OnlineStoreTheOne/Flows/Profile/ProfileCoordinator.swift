//
//  ProfileCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//

import UIKit

final class ProfileCoordinator: IProfileCoordinator{
    
    var flow: Flow
    
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    let storageService: StorageServiceProtocol
    
    // MARK: - Initialization
    init(flow: Flow, navigationController: UINavigationController) {
        self.flow = .profile
        self.navigationController = navigationController
        self.storageService = DIService.resolve(forKey: .storageService) ?? StorageService()
    }
    
    // MARK: - Coordinator Lifecycle
    func start() {
        showProfileScene()
    }
    
    // MARK: - Flow Presentation
    func showProfileScene() {
        let viewModel = ProfileViewModel(storageService: storageService)
        let viewController = ProfileViewController(viewModel: viewModel, coordinator: self)
        viewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: nil)
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
        let coordinator = OnboardingCoordinator(flow: .onboarding, finishDelegate: self, navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension ProfileCoordinator: ICoordinatorFinishDelete {
    func didFinish(_ coordinator: any ICoordinator) {
        
    }
}
