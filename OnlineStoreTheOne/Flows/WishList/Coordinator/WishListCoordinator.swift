//
//  WishListCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//


import UIKit

final class WishListCoordinator: IWishListCoordinator {
    
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    let networkService: NetworkServiceProtocol
    let storageService: StorageServiceProtocol
    
    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.networkService = DIService.resolve(forKey: .networkService) ?? NetworkService()
        self.storageService = DIService.resolve(forKey: .storageService) ?? StorageService()
    }
    
    // MARK: - Coordinator Lifecycle
    func start(_ flow: Flow? = nil) {
        showWishListScene()
    }
    
    // MARK: - Flow Presentation
    func showWishListScene() {
        let viewModel = WishListViewModel(networkService: networkService, storageService: storageService)
        let viewController = WishListViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showDetailFlow(_ id: Int) {
        let detailCoordinator = DetailCoordinator(
            navigationController: navigationController,
            productID: id
        )
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }
    
    func showCartsFlow() {
        let coordinator = CartsCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
