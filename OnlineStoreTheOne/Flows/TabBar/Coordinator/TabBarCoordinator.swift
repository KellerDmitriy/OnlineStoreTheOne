//
//  TabBarCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 09.05.2024.
//

import UIKit

enum Tabs {
    case home
    case wishList
    case manager
    case profile
}

final class TabBarCoordinator: ITabBarCoordinator {
    // MARK: - Properties
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController

    var childCoordinators: [ICoordinator] = []
    
    let networkService: NetworkServiceProtocol
    let storageService: StorageServiceProtocol
    
    // MARK: - Initialization
    init(
        navigationController: UINavigationController,
        networkService: NetworkServiceProtocol,
        storageService: StorageServiceProtocol
    ) {
        self.navigationController = navigationController
        self.networkService = networkService
        self.storageService = storageService
    }
    
    // MARK: - Coordinator Lifecycle
    func start(_ flow: Flow? = nil) {
        showHomeFlow()
    }
    
    // MARK: - Flow Presentation
    func showTabBar() {
//        let networkService: NetworkServiceProtocol = DIService.resolve()
//        let storageService: StorageServiceProtocol = DIService.resolve()
//        
//        let viewModel = HomeViewModel(networkService: networkService, storageService: storageService)
//        
//        let homeViewController = HomeViewController(viewModel: viewModel)
//        homeViewController.tabBarItem = UITabBarItem(
//            title: "Home",
//            image: UIImage(named: "home"),
//            tag: 0
//        )
//        
//        let wishListViewController = WishListViewController()
//        wishListViewController.tabBarItem = UITabBarItem(
//            title: "Wish List",
//            image: UIImage(named: "wishlist"),
//            tag: 1
//        )
//        
//        let managerViewController = ManagerViewController()
//        managerViewController.tabBarItem = UITabBarItem(
//            title: "Manager",
//            image: UIImage(named: "manager"),
//            tag: 2
//        )
//        
//        let profileViewController = ProfileViewController()
//        profileViewController.tabBarItem = UITabBarItem(
//            title: "Profile",
//            image: UIImage(named: "profile"),
//            tag: 3
//        )
//        
//        navigationController.setViewControllers([
//            homeViewController,
//            wishListViewController,
//            managerViewController,
//            profileViewController
//        ], animated: false
//        )
    }
    
    func showHomeFlow() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
    
    func showWishListFlow() {
        let wishListCoordinator = WishListCoordinator(navigationController: navigationController)
        childCoordinators.append(wishListCoordinator)
        wishListCoordinator.start()
    }
    
    func showManagerFlow() {
        let managerCoordinator = ManagerCoordinator(navigationController: navigationController)
        childCoordinators.append(managerCoordinator)
        managerCoordinator.start()
    }
    
    func showProfileFlow() {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        childCoordinators.append(profileCoordinator)
        profileCoordinator.start()
    }
}
