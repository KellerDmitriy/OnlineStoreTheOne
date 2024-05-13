//
//  HomeCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//

import UIKit

final class HomeCoordinator: IHomeCoordinator {

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
        showHomeScene()
    }
    
    // MARK: - Flow Presentation
    func showHomeScene() {
        let viewModel = HomeViewModel(networkService: networkService, storageService: storageService)
        let viewController = HomeViewController(viewModel: viewModel, coordinator: self)
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func showSearchResultScene(searchText: String? = nil) {
        let viewModel = SearchResultViewModel(
            searchText: searchText ?? "",
            networkService: networkService,
            storageService: storageService
        )
        let viewController = SearchResultViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
//        let searchResultsViewModel = SearchResultViewModel(searchText: "", networkService: NetworkService(), storageService: StorageService())
//        let searchResultsVC = SearchResultViewController(viewModel: searchResultsViewModel)
//        let navigationController = UINavigationController(rootViewController: searchResultsVC)
//        navigationController.modalPresentationStyle = .fullScreen
//        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showDetailFlow(productId: Int) {
        let detailCoordinator = DetailCoordinator(
            navigationController: navigationController,
            productID: productId
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

