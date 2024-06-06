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
    
    let networkService: NetworkServiceProtocol
    let storageService: StorageServiceProtocol
    
    // MARK: - Initialization
    init(type: CoordinatorType, finishDelegate: ICoordinatorFinishDelete, navigationController: UINavigationController) {
        self.type = .home
        self.finishDelegate = finishDelegate
        self.navigationController = navigationController
        self.networkService = DIService.resolve(forKey: .networkService) ?? NetworkService()
        self.storageService = DIService.resolve(forKey: .storageService) ?? StorageService()
    }
    
    // MARK: - Coordinator Lifecycle
    func start() {
        showHomeScene()
    }
    
    // MARK: - Flow Presentation
    func showHomeScene() {
        let viewModel = HomeViewModel(
            networkService: networkService,
            storageService: storageService
        )
        
        
        let viewController = HomeViewController(viewModel: viewModel, coordinator: self)
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

