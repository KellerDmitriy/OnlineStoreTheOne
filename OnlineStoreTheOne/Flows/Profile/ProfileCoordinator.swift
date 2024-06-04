//
//  ProfileCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//

import UIKit

final class ProfileCoordinator: IProfileCoordinator {
    // MARK: - Properties
    var type: CoordinatorType
    
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    let storageService: StorageServiceProtocol
    
    // MARK: - Initialization
    init(flow: CoordinatorType, finishDelegate: ICoordinatorFinishDelete?, navigationController: UINavigationController, storageService: StorageServiceProtocol) {
        self.type = .profile
        self.finishDelegate = finishDelegate
        self.navigationController = navigationController
        self.storageService = storageService
    }
    
    // MARK: - Coordinator Lifecycle
    func start() {
        showProfileScene()
    }
    
    // MARK: - Flow Presentation
    func showProfileScene() {
        let viewModel = ProfileViewModel(storageService: storageService)
        let viewController = ProfileViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showTypeOfAccountScene() {
        let viewController = TypeOfAccountViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showTermAndConditionScene() {
        let viewController = TermsConditionalViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}

