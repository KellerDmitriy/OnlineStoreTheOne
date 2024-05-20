//
//  TabBar.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//
import UIKit

final class TabBarController: UITabBarController {

    // MARK: - LifeCycle
    init(tabBarControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        for tab in tabBarControllers {
            self.addChild(tab)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarAppearance()
    }

    // MARK: - Private Methods
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
}
