//
//  SceneDelegate.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?
   
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        
        let context = Context()
        let startFlow = StartService().selectStartFlow(context: context)
        
        coordinator = AppCoordinator(
            window: window,
            flow: startFlow,
            context: context,
            navigationController: navigationController
        )
        coordinator?.start()
        
    }
}



