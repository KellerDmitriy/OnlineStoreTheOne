//
//  NavBarController.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 18.04.2024.
//

import UIKit

final class NavBarController: UINavigationController {

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        setupNavigationBarAppearance()
//        setupNavigationBarWithCustomButtons()
    }

    // MARK: - Customization Methods
    private func setupNavigationBarAppearance() {
        navigationBar.barTintColor = .white
        navigationBar.tintColor = .black
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationBar.addBottomBorder()
    }

    func setupNavigationBarWithCustomButtons() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: nil)
        backButton.title = "Back"
        navigationItem.leftBarButtonItem = backButton

        let cartButton = CartButton()
        let rightBarButton = UIBarButtonItem(customView: cartButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }
}
