//
//  SceneDelegate.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let storageService = StorageService.shared
        
//        let navVC = UINavigationController(rootViewController: HomeViewController())
//        window?.rootViewController = navVC
//        window?.makeKeyAndVisible()
        
        if storageService.isOnboardComplete() {
            let tabBarController = TabBarController()
            window?.rootViewController = tabBarController
            window?.makeKeyAndVisible()
        } else {
            let onboardController = OnboardingViewController()
            window?.rootViewController = onboardController
            window?.makeKeyAndVisible()
        }
    }
}



