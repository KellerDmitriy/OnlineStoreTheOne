//
//  HomeCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//

import UIKit

final class HomeCoordinator: IHomeCoordinator {
    let flow: Flow

    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    let networkService: NetworkServiceProtocol
    let storageService: StorageServiceProtocol
    
    // MARK: - Initialization
    init(flow: Flow, navigationController: UINavigationController) {
        self.flow = .home
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
        let viewModel = HomeViewModel(networkService: networkService, storageService: storageService)
        let viewController = HomeViewController(viewModel: viewModel, coordinator: self)
        viewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), selectedImage: nil)
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
            flow: .detail, 
            productID: productId,
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

