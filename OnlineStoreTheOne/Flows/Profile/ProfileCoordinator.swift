//
//  ProfileCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//

import UIKit

final class ProfileCoordinator: IProfileCoordinator {
    // MARK: - Properties
    var flow: Flow
    
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    let storageService: StorageServiceProtocol
    
    // MARK: - Initialization
    init(flow: Flow, finishDelegate: ICoordinatorFinishDelete?, navigationController: UINavigationController, storageService: StorageServiceProtocol) {
        self.flow = .profile
        self.finishDelegate = finishDelegate
        self.navigationController = navigationController
        self.storageService = storageService
    }
    
    // MARK: - Coordinator Lifecycle
    func start() {
        showProfileScene()
    }
    
    func finish() {
        finishDelegate?.didFinish(self)
    }
    
    // MARK: - Flow Presentation
    func showProfileScene() {
        let viewModel = ProfileViewModel(storageService: storageService)
        let viewController = ProfileViewController(viewModel: viewModel, coordinator: self)
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func showTypeOfAccountScene() {
        let viewController = TypeAccountViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showTermAndConditionScene() {
        let viewController = TermsConditionalViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

