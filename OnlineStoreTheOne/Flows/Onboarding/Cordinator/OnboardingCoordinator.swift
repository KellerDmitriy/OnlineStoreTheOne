//
//  OnboardingCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 10.05.2024.
//

import UIKit

final class OnboardingCoordinator: IOnboardingCoordinator {
    let flow: Flow
    
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    // MARK: - Initialization
    init(flow: Flow, finishDelegate: ICoordinatorFinishDelete?, navigationController: UINavigationController) {
        self.flow = flow
        self.finishDelegate = finishDelegate
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator Lifecycle
    func start() {
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
