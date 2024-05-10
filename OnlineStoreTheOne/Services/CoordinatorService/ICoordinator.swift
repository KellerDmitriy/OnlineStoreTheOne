//
//  ICoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 09.05.2024.
//

import UIKit

protocol ICoordinatorFinishDelete {
    func didFinish(_ coordinator: ICoordinator)
}

protocol ICoordinator: AnyObject {
    var finishDelegate: ICoordinatorFinishDelete? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [ICoordinator] { get set }
    
    func start(_ flow: Flow?)
    func finish()
}

extension ICoordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.didFinish(self)
    }
}

protocol IAppCoordinator: ICoordinator {
    func showOnboardingFlow()
    func showAuthFlow()
    func showTabBarFlow()
}

protocol IAuthCoordinator: ICoordinator {
    func showLoginScene()
    func showRegistationScene()
}

protocol ITabBarCoordinator: ICoordinator {
    func showTabBar()
    func showHomeFlow()
    func showWishListFlow()
    func showManagerFlow()
    func showProfileFlow()
}

protocol IOnboardingCoordinator: ICoordinator {
    func showOnboardingScene()
    func showStartFlow(_ flow: Flow?)
}

protocol IHomeCoordinator: ICoordinator {
    func showHomeScene()
    func showSearchResultScene(searchText: String?)
    func showDetailScene(productId: Int)
    func showCartsScene()
}

protocol IWishListCoordinator: ICoordinator {
    func showWishListScene()
    func showDetailScene()
    func showCartsScene()
}

protocol IManagerCoordinator: ICoordinator {
    func showManagerScene()
}

protocol IProfileCoordinator: ICoordinator {
    func showProfileScene()
    func showOnboardingScene()
    func showTypeOfAccountScene()
    func TermAndConditionScene()
}
