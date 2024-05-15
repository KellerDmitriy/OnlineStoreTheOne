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
        
        let context = Context()
        
        let navigationController = UINavigationController()
        navigationController.setupNavigationBar()
        let appCoordinator = AppCoordinator(navigationController: navigationController, context: context)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let startFlow = StartEntity().selectStartFlow(context: context)
        appCoordinator.start(startFlow)
        
    }
}



