//
//  AppCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 09.05.2024.
//

import UIKit

final class AppCoordinator: Coordinator {
    // MARK: - Coordinator Lifecycle
    override func start() {
        showTabBarFlow()
    }
    
    override func finish() {
        
    }
    
    // MARK: - Flow Presentation
    func showOnboardingFlow() {
        let onboardingCoordinator = OnboardingCoordinator(flow: .onboarding, finishDelegate: self, navigationController: navigationController)
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func showAuthFlow() {
        let authCoordinator = AuthCoordinator(flow: .auth, navigationController: navigationController)
        authCoordinator.finishDelegate = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    func showTabBarFlow() {

        let homeNavigationController = UINavigationController()
        let homeCoordinator = HomeCoordinator(flow: .home, navigationController: homeNavigationController)
        homeNavigationController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "Home"),
            selectedImage: UIImage(named: "selectedHome")
        )
        homeCoordinator.finishDelegate = self
        homeCoordinator.start()

        let wishListNavigationController = UINavigationController()
        let wishListCoordinator = WishListCoordinator(flow: .wishList, navigationController: wishListNavigationController)
        wishListNavigationController.tabBarItem = UITabBarItem(
            title: "Wish List",
            image: UIImage(named: "Wishlist"),
            selectedImage: UIImage(named: "selectedWishlist")
        )

       wishListCoordinator.finishDelegate = self
       wishListCoordinator.start()
        
        let managerNavigationController = UINavigationController()
        let managerCoordinator = ManagerCoordinator(flow: .manager, navigationController: managerNavigationController)
        managerNavigationController.tabBarItem = UITabBarItem(
            title: "Manager",
            image: UIImage(named: "Manager"),
            selectedImage: UIImage(named: "selectedManager")
        )

       managerCoordinator.finishDelegate = self
       managerCoordinator.start()
        
        let profileNavigationController = UINavigationController()
        let profileCoordinator = ProfileCoordinator(flow: .profile, navigationController: profileNavigationController)
        profileNavigationController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(named: "Profile"),
            selectedImage: UIImage(named: "selectedProfile")
        )

       profileCoordinator.finishDelegate = self
       profileCoordinator.start()
        
        addChildCoordinator(homeCoordinator)
        addChildCoordinator(wishListCoordinator)
        addChildCoordinator(managerCoordinator)
        addChildCoordinator(profileCoordinator)
        
        let tabBarControllers = [
            homeNavigationController,
            wishListNavigationController,
            managerNavigationController,
            profileNavigationController
        ]
        let tabBarController = TabBarController(tabBarControllers: tabBarControllers)
        navigationController.pushViewController(tabBarController, animated: true)
    }
}

