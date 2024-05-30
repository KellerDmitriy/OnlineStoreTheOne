//
//  ICoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 09.05.2024.
//

import UIKit

enum CoordinatorType {
    case onboarding
    case auth
    case tabBar
    case home
    case search
    case wishList
    case detail
    case carts
    case manager
    case profile
}

protocol ICoordinatorFinishDelete {
    func didFinish(_ coordinator: ICoordinator)
}

protocol ICoordinator: AnyObject {
    var type: CoordinatorType { get }
    var finishDelegate: ICoordinatorFinishDelete? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [ICoordinator] { get set }
    
    func start()
    func finish()
}

extension ICoordinator {
    func showAlertController(
        title: String,
        message: String,
        titleDefaultAction: String = "Ok",
        titleDestructiveAction: String = "Cancel",
        createAction: @escaping () -> Void
    ) {
        let alert = UIAlertFactory.createAlert(
            title: title,
            message: message,
            titleDefaultAction: titleDefaultAction,
            titleDestructiveAction: titleDestructiveAction,
            completion: createAction
        )
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    func addChildCoordinator(_ child: ICoordinator) {
        childCoordinators.append(child)
    }
    
    func removeChildCoordinator(_ child: ICoordinator) {
        childCoordinators = childCoordinators.filter{ $0 !== child }
    }
    
    func finish() {
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

protocol IOnboardingCoordinator: ICoordinator {
    func showOnboardingScene()
}

protocol IHomeCoordinator: ICoordinator {
    func showHomeScene()
    func showSearchResultFlow()
    
    func showCartsFlow()
    func showDetailFlow(productId: Int)
}

protocol ISearchResultCoordinator: ICoordinator {
    func showSearchResultScene(searchText: String?)
    
    func showDetailFlow(productId: Int)
    func showCartsFlow()
    
}

protocol IDetailCoordinator: ICoordinator {
    func showDetailScene(_ id: Int)
    func showPayScene()
    
    func showCartsFlow()
}

protocol ICartsCoordinator: ICoordinator {
    func showCartsScene()
    func showPayScene()
}

protocol IWishListCoordinator: ICoordinator {
    func showWishListScene()
    
    func showDetailFlow(_ id: Int)
    func showCartsFlow()
}

protocol IManagerCoordinator: ICoordinator {
    func showManagerScene()
}

protocol IProfileCoordinator: ICoordinator {
    func showProfileScene()
    func showTypeOfAccountScene()
    func showTermAndConditionScene()
}
