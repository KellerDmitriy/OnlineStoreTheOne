//
//  CartsCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//

import UIKit

final class CartsCoordinator: ICartsCoordinator {
    let type: CoordinatorType
    
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    let networkService: NetworkServiceProtocol
    let storageService: StorageServiceProtocol
    
    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.type = .carts
        self.navigationController = navigationController
        self.networkService = DIService.resolve(forKey: .networkService) ?? NetworkService()
        self.storageService = DIService.resolve(forKey: .storageService) ?? StorageService()
    }
    
    // MARK: - Coordinator Lifecycle
    func start() {
        showCartsScene()
    }
    
    // MARK: - Flow Presentation
    func showCartsScene() {
        let viewModel = CartsViewModel(
            coordinator: self,
            networkService: networkService,
            storageService: storageService
        )
        let viewController = CartsViewController(viewModel: viewModel)
        navigationController.navigationBar.isHidden = true
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    func showPayScene() {
        let viewController = PaymentSuccessView()
        if let presentationController = viewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
            navigationController.present(viewController, animated: true)
        }
    }
}
