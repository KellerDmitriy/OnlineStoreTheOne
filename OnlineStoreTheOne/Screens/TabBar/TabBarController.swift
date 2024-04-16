//
//  TabBar.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//
import UIKit

final class TabBarController: UITabBarController {

        // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabBarAppearance()
        setupViewControllers()
    }
    
    // MARK: - private methods
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground

        appearance.stackedLayoutAppearance.normal.iconColor = Colors.gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: Colors.gray]
        
        appearance.stackedLayoutAppearance.selected.iconColor = Colors.greenSheen
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: Colors.greenSheen]
        
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = Colors.gray

    }

    private func setupViewControllers() {
        
        let vc1 = UINavigationController(rootViewController: ViewController())
        let vc2 = UINavigationController(rootViewController: ViewController())
        let vc3 = UINavigationController(rootViewController: ViewController())
        let vc4 = UINavigationController(rootViewController: ProfileScreen())

        vc1.title = "Home"
        vc2.title = "Categories"
        vc3.title = "Likes"
        vc4.title = "Account"

        vc1.tabBarItem.image = UIImage(named: "Home")
        vc2.tabBarItem.image = UIImage(named: "Wishlist")
        vc3.tabBarItem.image = UIImage(named: "Manager")
        vc4.tabBarItem.image = UIImage(named: "Account")

        vc1.tabBarItem.selectedImage = UIImage(named: "selectedHome")
        vc2.tabBarItem.selectedImage = UIImage(named: "selectedWishlist")
        vc3.tabBarItem.selectedImage = UIImage(named: "selectedManager")
        vc4.tabBarItem.selectedImage = UIImage(named: "selectedAccount")

        tabBar.tintColor = .black
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}
