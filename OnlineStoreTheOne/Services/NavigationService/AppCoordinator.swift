//
//  AppCoordinator.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 09.05.2024.
//

import UIKit

final class AppCoordinator: ICoordinator {
    // MARK: - Properties
    var type: CoordinatorType
    let context: Context
    private let window: UIWindow?
    
    var finishDelegate: ICoordinatorFinishDelete?
    var navigationController: UINavigationController
    var childCoordinators: [ICoordinator] = []
    
    let networkService: NetworkServiceProtocol
    let storageService: StorageServiceProtocol
    
    // MARK: - Initialization
    init(window: UIWindow?, flow: CoordinatorType, context: Context, navigationController: UINavigationController) {
        self.window = window
        self.type = flow
        self.context = context
        self.navigationController = navigationController
        self.networkService = DIService.resolve(forKey: .networkService) ?? NetworkService()
        self.storageService = DIService.resolve(forKey: .storageService) ?? StorageService()
    }
    
    deinit {
        childCoordinators.forEach { $0.finishDelegate = nil }
        childCoordinators.removeAll()
    }
    
    // MARK: - Coordinator Lifecycle
    func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        switch type {
        case .onboarding:
            showOnboardingFlow()
        case .auth:
            showAuthFlow()
        case .tabBar:
            showTabBarFlow()
        case .home:
            showTabBarFlow()
        case .search:
            showTabBarFlow()
        case .wishList:
            showTabBarFlow()
        case .detail:
            showTabBarFlow()
        case .carts:
            showTabBarFlow()
        case .manager:
            showTabBarFlow()
        case .profile:
            showTabBarFlow()
        }
    }
    
    func finish() {
        finishDelegate?.didFinish(self)
    }
    
    // MARK: - Flow Presentation
    func showOnboardingFlow() {
        let onboardingCoordinator = OnboardingCoordinator(
            flow: .onboarding,
            finishDelegate: self,
            navigationController: navigationController
        )
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func showAuthFlow() {
        let authCoordinator = AuthCoordinator(
            flow: .auth, 
            finishDelegate: self,
            navigationController: navigationController
        )
       
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    func showTabBarFlow() {
        let homeNavigationController = CustomNavigationController()
        let homeCoordinator = HomeCoordinator(
            type: .home, 
            finishDelegate: self,
            navigationController: homeNavigationController
        )
        homeNavigationController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "Home"),
            selectedImage: UIImage(named: "selectedHome")
        )
        homeCoordinator.start()
        
        let wishListNavigationController = CustomNavigationController()
        let wishListCoordinator = WishListCoordinator(
            flow: .wishList, 
            finishDelegate: self,
            navigationController: wishListNavigationController
        )
        wishListNavigationController.tabBarItem = UITabBarItem(
            title: "Wish List",
            image: UIImage(named: "Wishlist"),
            selectedImage: UIImage(named: "selectedWishlist")
        )
        
        wishListCoordinator.finishDelegate = self
        wishListCoordinator.start()
        
        let managerNavigationController = UINavigationController()
        let managerCoordinator = ManagerCoordinator(
            flow: .manager, 
            finishDelegate: self,
            navigationController: managerNavigationController
        )
        managerNavigationController.tabBarItem = UITabBarItem(
            title: "Manager",
            image: UIImage(named: "Manager"),
            selectedImage: UIImage(named: "selectedManager")
        )
        
        managerCoordinator.finishDelegate = self
        managerCoordinator.start()
        
        let profileNavigationController = CustomNavigationController()
        let profileCoordinator = ProfileCoordinator(
            flow: .profile, 
            finishDelegate: self,
            navigationController: profileNavigationController,
            storageService: storageService
        )
        profileNavigationController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(named: "ProfileTab"),
            selectedImage: UIImage(named: "selectedProfile")
        )
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
        window?.rootViewController = tabBarController
    }
}

//MARK: - ICoordinatorFinishDelete
extension AppCoordinator: ICoordinatorFinishDelete {
 
    func didFinish(_ childCoordinator: ICoordinator) {
        removeChildCoordinator(childCoordinator)
        switch childCoordinator.type {
            
        case .onboarding:
            context.isOnboardComplete = true
            type = StartEntity().selectStartFlow(context: context)
            start()
            navigationController.viewControllers = [navigationController.viewControllers.last ?? UIViewController()]
        case .auth:
            type = StartEntity().selectStartFlow(context: context)
            start()
            navigationController.viewControllers = [navigationController.viewControllers.last ?? UIViewController()]
        case .tabBar:
            type = .tabBar
        case .home:
            return finish()
        case .search:
            type = .home
            start()
            navigationController.viewControllers = [navigationController.viewControllers.last ?? UIViewController()]
        case .wishList:
            return finish()
        case .detail:
            return finish()
        case .carts:
            navigationController.viewControllers = [navigationController.viewControllers.last ?? UIViewController()]
        case .manager:
            return finish()
        case .profile:
            context.isOnboardComplete = false
            type = StartEntity().selectStartFlow(context: context)
            start()
            navigationController.viewControllers = [navigationController.viewControllers.last ?? UIViewController()]
        }
    }
}

