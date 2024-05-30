//
//  NavigationController.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 28.05.2024.
//

import UIKit

final class CustomNavigationController: UINavigationController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    func configure() {
        view.backgroundColor = .systemBackground
        navigationBar.isTranslucent = false
        navigationBar.standardAppearance.titleTextAttributes = [
            .foregroundColor: Colors.darkArsenic,
            .font: UIFont.makeTypography(.semiBold, size: 17)
        ]
        
        navigationBar.addBottomBorder()
    }

}
