//
//  ManagerCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//

import UIKit

final class ManagerCoordinator: ICoordinator {
    let flow: Flow

    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    
    // MARK: - Initialization
    init(flow: Flow, navigationController: UINavigationController) {
        self.flow = .manager
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator Lifecycle
    func start() {
        showManagerScene()
    }
    
    // MARK: - Flow Presentation
    func showManagerScene() {
        let viewController = ManagerViewController()
        viewController.tabBarItem = UITabBarItem(title: "Manager", image: UIImage(named: "manager"), selectedImage: nil)
        navigationController.pushViewController(viewController, animated: true)
    }

}

