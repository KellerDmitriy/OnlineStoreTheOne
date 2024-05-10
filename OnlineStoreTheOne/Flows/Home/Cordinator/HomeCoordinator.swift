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
    
    let networkService: NetworkServiceProtocol = DIService.resolve()
    let storageService: StorageServiceProtocol = DIService.resolve()
    
    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator Lifecycle
    func start(_ flow: Flow? = nil) {
        showHomeScene()
    }
    
    // MARK: - Flow Presentation
    func showHomeScene() {
        let viewModel = HomeViewModel(networkService: networkService, storageService: storageService)
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showSearchResultScene(searchText: String? = nil) {
        let viewModel = SearchResultViewModel(
            searchText: searchText ?? "",
            networkService: networkService,
            storageService: storageService
        )
        let viewController = SearchResultViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showDetailScene(productId: Int) {
        let detailViewModel = DetailsProductViewModel(
            productId: productId,
            networkService: networkService,
            storageService: storageService
        )
        
        let detailViewController = DetailsViewController(viewModel: detailViewModel)
        let navigationController = UINavigationController(rootViewController: detailViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.present(navigationController, animated: true, completion: nil)
    }
    
    func showCartsScene() {
        let viewModel = CartsViewModel(
            networkService: networkService,
            storageService: storageService
        )
        let viewController = CartsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

