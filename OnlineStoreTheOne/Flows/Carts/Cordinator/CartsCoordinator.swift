//
//  CartsCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//

import UIKit

final class CartsCoordinator: ICoordinator {
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    
    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator Lifecycle
    func start(_ flow: Flow? = nil) {
        showCartsScene()
    }
    
    // MARK: - Flow Presentation
    func showCartsScene() {
//        let viewController = CartsViewController()
//        navigationController.pushViewController(viewController, animated: true)
    }

}
