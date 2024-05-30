//
//  BaseViewController.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 28.05.2024.
//

import UIKit
enum NavBarButtonType {
    case backButton
    case cartButton
}

class BaseViewController: UIViewController {
    let backButton = BackButton()
    let cartButton = CartButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
        configure()
    }
}

@objc
extension BaseViewController {
    
    func addViews() {}
    func setupConstraints() {}
    func configure() {
        view.backgroundColor = .systemBackground
    }
    
    func backBarButtonTap() {}
    
    func cartBarButtonTap() {}
}


extension BaseViewController {
    
    func addNavBarButton(at type: NavBarButtonType) {
        switch type {
        case .backButton:
          
            backButton.addTarget(self, action: #selector(backBarButtonTap), for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        case .cartButton:
           
            cartButton.addTarget(self, action: #selector(cartBarButtonTap), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        }
    }
}
