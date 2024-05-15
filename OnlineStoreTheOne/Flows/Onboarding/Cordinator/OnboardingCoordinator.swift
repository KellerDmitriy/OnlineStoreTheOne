//
//  OnboardingCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//

import UIKit

final class OnboardingCoordinator: IOnboardingCoordinator {
    
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator Lifecycle
    func start(_ flow: Flow? = nil) {
        showOnboardingScene()
    }
    
    func finish() {
        finishDelegate?.didFinish(self)
    }
    
    // MARK: - Flow Presentation
    func showOnboardingScene() {
        let viewModel = OnboardingViewModel()
        let viewController = OnboardingViewController(viewModel: viewModel, coordinator: self)
        
        navigationController.setViewControllers([viewController], animated: true)
    }
}
