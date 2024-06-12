//
//  AuthCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 09.05.2024.
//

import UIKit

final class AuthCoordinator: IAuthCoordinator {
    // MARK: - Properties
    let type: CoordinatorType
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    // MARK: - Initialization
    init(flow: CoordinatorType, finishDelegate: ICoordinatorFinishDelete?, navigationController: UINavigationController) {
        self.type = .auth
        self.finishDelegate = finishDelegate
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator Lifecycle
    func start() {
        showLoginScene()
    }

    // MARK: - Flow Presentation
    func showLoginScene() {
        let viewModel = LoginViewModel(coordinator: self)
        let viewController = LoginViewController( viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func showRegistationScene() {
        let viewModel = RegistrationViewModel(coordinator: self)
        let viewController = RegistrationViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
