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
        
        if isOnboardComplete() {
            let tabBarController = TabBarController()
            let navigationController = UINavigationController(rootViewController: tabBarController)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        } else {
            let onboardController = OnboardingViewController()
            let navigationController = UINavigationController(rootViewController: onboardController)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }
    
    func isOnboardComplete() -> Bool {
        UserDefaults.standard.bool(forKey: "OnboardCompleted")
    }

}





