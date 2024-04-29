//
//  TabBar.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//
import UIKit
import FirebaseAuth

final class TabBarController: UITabBarController {
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        authenticateUser()
        configureTabBarAppearance()
        setupViewControllers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleVisibilityChange(notification:)), name: .updateTabBarVisibility, object: nil)
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
        navigationItem.hidesBackButton = true
    }
    
    private func setupViewControllers() {
        
        let vc1 = UINavigationController(
            rootViewController: HomeViewController()
        )
        let vc2 = UINavigationController(
            rootViewController: WishListViewController()
        )
        let vc3 = UINavigationController(
            rootViewController: ManagerViewController()
        )
        let vc4 = UINavigationController(
            rootViewController: ProfileViewController()
        )
        
        vc1.title = "Home"
        vc2.title = "Wishlist"
        vc3.title = "Manager"
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
        
        if let type = UserDefaults.standard.object(forKey: "accountType") as? String {
            switch type {
            case "Manager":
                let viewControllers = [vc1, vc2, vc3, vc4]
                setViewControllers(viewControllers, animated: true)
                selectedIndex = 0
            case "User":
                let viewControllers = [vc1, vc2, vc4]
                setViewControllers(viewControllers, animated: true)
                selectedIndex = 0
            default:
                break
            }
        }
    }

    private func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
        }
    }
    
    private func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginViewController()
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        }
    }
    
    @objc private func handleVisibilityChange(notification: Notification) {
            setupViewControllers()
    }
}

extension Notification.Name {
    static let updateTabBarVisibility = Notification.Name("updateTabBarVisibility")
}
