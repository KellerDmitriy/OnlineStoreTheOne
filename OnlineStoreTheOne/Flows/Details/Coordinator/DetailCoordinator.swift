//
//  DetailCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 12.05.2024.
//

import UIKit

final class DetailCoordinator: IDetailCoordinator {
    // MARK: - Properties
    let flow: Flow
    
    var productID: Int
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    let networkService: NetworkServiceProtocol
    let storageService: StorageServiceProtocol
    
    // MARK: - Initialization
    init(flow: Flow, productID: Int, navigationController: UINavigationController) {
        self.flow = .detail
        self.productID = productID
        self.navigationController = navigationController
        self.networkService = DIService.resolve(forKey: DIKey.networkService) ?? NetworkService()
        self.storageService = DIService.resolve(forKey: DIKey.storageService) ?? StorageService()
    }
    
    // MARK: - Coordinator Lifecycle
    func start() {
        showDetailScene(productID)
    }
    
    // MARK: - Flow Presentation
    func showDetailScene(_ id: Int) {
        let detailViewModel = DetailsProductViewModel(
            productId: id,
            networkService: networkService,
            storageService: storageService
        )
        
        let detailViewController = DetailsViewController(viewModel: detailViewModel, coordinator: self)
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    
    func showPayScene() {
        let viewController = PaymentSuccessView()
        if let presentationController = viewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
            navigationController.present(viewController, animated: true)
        }
    }

    func showCartsFlow() {
        let coordinator = CartsCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
