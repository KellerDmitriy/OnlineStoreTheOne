//
//  HomeCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//

import UIKit

final class HomeCoordinator: IHomeCoordinator {
    // MARK: - Properties
    let type: CoordinatorType

    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    
    // MARK: - Initialization
    init(type: CoordinatorType, finishDelegate: ICoordinatorFinishDelete, navigationController: UINavigationController) {
        self.type = .home
        self.finishDelegate = finishDelegate
        self.navigationController = navigationController

    }
    
    // MARK: - Coordinator Lifecycle
    func start() {
        showHomeScene()
    }
    
    // MARK: - Flow Presentation
    func showHomeScene() {
        let viewModel = HomeViewModel(coordinator: self)
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController.navigationBar.isHidden = true
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func showSearchResultFlow() {
        navigationController.navigationBar.isHidden = true
        
        let searchResultCoordinator = SearchResultCoordinator(
            flow: .search,
            finishDelegate: finishDelegate,
            navigationController: navigationController
        )
        childCoordinators.append(searchResultCoordinator)
        searchResultCoordinator.start()
    }
    
    func showDetailFlow(productId: Int) {
        navigationController.navigationBar.isHidden = false
        
        let detailCoordinator = DetailCoordinator(
            type: .detail, 
            productID: productId, 
            finishDelegate: finishDelegate,
            navigationController: navigationController
        )
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }
    
    func showCartsFlow() {
        let coordinator = CartsCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

