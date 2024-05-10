//
//  WishListCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//


import UIKit

final class WishListCoordinator: ICoordinator {
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    
    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator Lifecycle
    func start(_ flow: Flow? = nil) {
        showWishListScene()
    }
    
    // MARK: - Flow Presentation
    func showWishListScene() {
        let viewController = WishListViewController(viewModel: <#WishListViewModel#>)
        navigationController.pushViewController(viewController, animated: true)
    }

}
