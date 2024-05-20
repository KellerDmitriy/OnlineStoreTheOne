//
//  WishListCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//


import UIKit

final class WishListCoordinator: IWishListCoordinator {
    // MARK: - Properties
    let flow: Flow
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    let networkService: NetworkServiceProtocol
    let storageService: StorageServiceProtocol
    
    // MARK: - Initialization
    init(flow: Flow, navigationController: UINavigationController) {
        self.flow = .wishList
        self.navigationController = navigationController
        self.networkService = DIService.resolve(forKey: .networkService) ?? NetworkService()
        self.storageService = DIService.resolve(forKey: .storageService) ?? StorageService()
    }
    
    // MARK: - Coordinator Lifecycle
    func start() {
        showWishListScene()
    }
    
    // MARK: - Flow Presentation
    func showWishListScene() {
        let viewModel = WishListViewModel(networkService: networkService, storageService: storageService)
        let viewController = WishListViewController(viewModel: viewModel, coordinator: self)
        viewController.tabBarItem = UITabBarItem(title: "Wish List", image: UIImage(named: "wishlist"), selectedImage: nil)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showDetailFlow(_ id: Int) {
        let detailCoordinator = DetailCoordinator(
            flow: .detail, 
            productID: id,
            navigationController: navigationController
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
