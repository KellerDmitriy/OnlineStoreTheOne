//
//  TabBarCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 09.05.2024.
//

import UIKit


final class TabBarCoordinator: ITabBarCoordinator {
    
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    
    var childCoordinators: [any ICoordinator] = []
    
    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator Lifecycle
    func start(_ flow: Flow? = nil) {
        
        let tabBarController = TabBarController()
        setupViewControllers(for: tabBarController)
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    // MARK: - Flow Presentation
    func setupViewControllers(for tabBarController: UITabBarController) {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        let wishListCoordinator = WishListCoordinator(navigationController: navigationController)
        let managerCoordinator = ManagerCoordinator(navigationController: navigationController)
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        
        homeCoordinator.start()
        wishListCoordinator.start()
        managerCoordinator.start()
        profileCoordinator.start()
        
        homeCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "home"),
            tag: 0
        )
        wishListCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Wish List",
            image: UIImage(named: "wishlist"),
            tag: 1
        )
        managerCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Manager",
            image: UIImage(named: "manager"),
            tag: 2
        )
        profileCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Account",
            image: UIImage(named: "profile"),
            tag: 3
        )
        
        tabBarController.viewControllers = []
    }
}
