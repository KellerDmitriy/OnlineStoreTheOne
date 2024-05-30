//
//  SearchResultCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 28.05.2024.
//

import UIKit

final class SearchResultCoordinator: ISearchResultCoordinator {
    // MARK: - Properties
    var type: CoordinatorType
    
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    
    var childCoordinators: [ICoordinator] = []
    
    let networkService: NetworkServiceProtocol
    let storageService: StorageServiceProtocol
    
    // MARK: - Initialization
    init(flow: CoordinatorType, finishDelegate: ICoordinatorFinishDelete?, navigationController: UINavigationController) {
        self.type = .wishList
        self.finishDelegate = finishDelegate
        self.navigationController = navigationController
        
        self.networkService = DIService.resolve(forKey: .networkService) ?? NetworkService()
        self.storageService = DIService.resolve(forKey: .storageService) ?? StorageService()
    }
    
    // MARK: - Coordinator Lifecycle
    func start() {
        showSearchResultScene(searchText: "")
    }
    
    // MARK: - Flow Presentation
    func showSearchResultScene(searchText: String?) {
        let viewModel = SearchResultViewModel(
            searchText: searchText ?? "",
            networkService: networkService,
            storageService: storageService
        )
        let viewController = SearchResultViewController(
            viewModel: viewModel,
            coordinator: self
        )
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showDetailFlow(productId id: Int) {
        let detailCoordinator = DetailCoordinator(
            flow: .detail,
            productID: id,
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
