//
//  AuthCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 09.05.2024.
//

import UIKit

final class AuthCoordinator: IAuthCoordinator {
    // MARK: - Properties
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator Lifecycle
    func start(_ flow: Flow? = nil) {
        showLoginScene()
    }
    
    // MARK: - Flow Presentation
    func showLoginScene() {
        let viewModel = LoginViewModel()
        let viewController = LoginViewController(coordinator: self, viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func showRegistationScene() {
        let viewModel = RegistrationViewModel()
        let viewController = RegistrationViewController(coordinator: self, viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
