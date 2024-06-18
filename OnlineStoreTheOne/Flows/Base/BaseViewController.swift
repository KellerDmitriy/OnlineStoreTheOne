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

protocol IBaseViewController: AnyObject {
    func configureNavigationBar() -> CustomNavigationBarConfiguration?
}

class BaseViewController: UIViewController, IBaseViewController {
    
    var customNavigationBar = CustomNavigationBarImpl()
    
    lazy var backButton = customNavigationBar.backButton
    lazy var cartButton = customNavigationBar.cartButton
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
        configure()
        
        customNavigationBar.setupConfiguration(configureNavigationBar())
        addActionForNavBarButton(at: .cartButton)
        addActionForNavBarButton(at: .backButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartButtonCount(_:)), name: NSNotification.Name("getCartsCount"), object: nil)
        
        updateCartButtonCount(nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartButtonCount(nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - IBaseViewController
    func configureNavigationBar() -> CustomNavigationBarConfiguration? { nil }
    
}

@objc
extension BaseViewController {
    
    // MARK: - Notification Handling
        func updateCartButtonCount(_ notification: Notification?) {
            let count = notification?.userInfo?["count"] as? Int ?? StorageService().getCartsCount()
            cartButton.count = count
        }
    
    // MARK: - Configuration
    func configure() {
        view.backgroundColor = .systemBackground
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
       
    }
    
    // MARK: - Actions
    func backBarButtonTap() {}
    func cartBarButtonTap() {}
    
    // MARK: - Setup Methods
    func addViews() {
        view.addSubview(customNavigationBar)
        view.bringSubviewToFront(customNavigationBar)
    }
    
    func setupConstraints() {
        customNavigationBar.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}

extension BaseViewController {
    // MARK: - Navigation Bar Button Actions
    func addActionForNavBarButton(at type: NavBarButtonType) {
        switch type {
        case .backButton:
            backButton.addTarget(self, action: #selector(backBarButtonTap), for: .touchUpInside)
        case .cartButton:
            cartButton.addTarget(self, action: #selector(cartBarButtonTap), for: .touchUpInside)
        }
    }
}
