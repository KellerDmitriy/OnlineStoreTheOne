//
//  AuthCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 09.05.2024.
//

import UIKit

final class AuthCoordinator: IAuthCoordinator {
    // MARK: - Properties
    let flow: Flow
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    // MARK: - Initialization
    init(flow: Flow, navigationController: UINavigationController) {
        self.flow = .auth
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator Lifecycle
    func start() {
        showLoginScene()
    }
    
    func finish() {
        finishDelegate?.didFinish(self)
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
