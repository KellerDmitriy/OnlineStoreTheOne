//
//  ManagerCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//

import UIKit

final class ManagerCoordinator: ICoordinator {
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    
    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator Lifecycle
    func start(_ flow: Flow? = nil) {
        showManagerScene()
    }
    
    // MARK: - Flow Presentation
    func showManagerScene() {
        let viewController = ManagerViewController()
        navigationController.pushViewController(viewController, animated: true)
    }

}

