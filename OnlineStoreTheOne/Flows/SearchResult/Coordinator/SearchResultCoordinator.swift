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
    
    
    // MARK: - Initialization
    init(flow: CoordinatorType, finishDelegate: ICoordinatorFinishDelete?, navigationController: UINavigationController) {
        self.type = .wishList
        self.finishDelegate = finishDelegate
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator Lifecycle
    func start() {
        showSearchResultScene(searchText: "")
    }
    
    // MARK: - Flow Presentation
    func showSearchResultScene(searchText: String?) {
        let viewModel = SearchResultViewModel(
            searchText: searchText ?? "",
            coordinator: self
        )
        let viewController = SearchResultViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showDetailFlow(_ id: Int) {
        let detailCoordinator = DetailCoordinator(
            type: .detail,
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
