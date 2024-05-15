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
    func showAlertController(title: String, message: String, createAction: @escaping (String) -> Void) {
        let alert = UIAlertFactory.createAlert(title: title, message: message, completion: createAction)
        navigationController.present(alert, animated: true, completion: nil)
    }
    
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
    func setupViewControllers(for tabBarController: UITabBarController)
}

protocol IOnboardingCoordinator: ICoordinator {
    func showOnboardingScene()
}

protocol IHomeCoordinator: ICoordinator {
    func showHomeScene()
    func showSearchResultScene(searchText: String?)
    
    func showCartsFlow()
    func showDetailFlow(productId: Int)
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
    
    func showOnboardingFlow()
}
