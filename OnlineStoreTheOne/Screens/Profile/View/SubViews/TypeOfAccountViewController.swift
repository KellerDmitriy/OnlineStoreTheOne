//
//  TypeOfAccountViewController.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 18.04.2024.
//

import UIKit
import FirebaseAuth

enum TypeOfAccount: String {
    case manager = "Manager"
    case user = "User"
}

final class TypeOfAccountViewController: UIViewController {
    //MARK: - UI elements
    private lazy var managerButton: (UIButton, UILabel, UIView) = {
        let button = ButtonLabelFactory(
            title: "Manager",
            type: .standartButton,
            name: "CheckIcon",
            action: managerBtnTapped(),
            textColor: nil)
            .createButtonWithLabel()
        button.0.backgroundColor = Colors.greenSheen
        button.1.textColor = .white
        return button
    }()
    
    private lazy var userButton: (UIButton, UILabel, UIView) = {
        let button = ButtonLabelFactory(
            title: "User",
            type: .standartButton,
            name: "CheckIcon",
            
            action: userBtnTapped(),
            textColor: nil)
            .createButtonWithLabel()
        return button
    }()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setConstraint()
        navigationItem.title = "Type of Account"
        navigationController?.setupNavigationBar()
        navigationController?.navigationBar.addBottomBorder()
        setupButtons()
    }
}

//MARK: - Extension
private extension TypeOfAccountViewController {
    
    private func setupButtons() {
        if let type = UserDefaults.standard.object(forKey: "accountType") as? String {
            switch type {
            case TypeOfAccount.manager.rawValue:
                self.managerButton.0.backgroundColor = Colors.greenSheen
                self.managerButton.1.textColor = .white
                self.view.bringSubviewToFront(self.managerButton.2)
                
                self.userButton.0.backgroundColor = Colors.lightGray
                self.userButton.1.textColor = Colors.darkArsenic
                self.view.sendSubviewToBack(self.userButton.2)
            case TypeOfAccount.user.rawValue:
                self.managerButton.0.backgroundColor = Colors.lightGray
                self.managerButton.1.textColor = Colors.darkArsenic
                self.view.sendSubviewToBack(self.managerButton.2)
                
                self.userButton.0.backgroundColor = Colors.greenSheen
                self.userButton.1.textColor = .white
                self.view.bringSubviewToFront(self.userButton.2)
            default:
                break
            }
        }
        
    }
    
    private func updateTabBar() {
        NotificationCenter.default.post(name: .updateTabBarVisibility, object: nil)
    }
    
    private func updateAccount(type: String) {
        if let user = Auth.auth().currentUser {
            AuthService.shared.changeAccountType(userId: user.uid, type: type)
        }
    }
    
    //MARK: -  Action
    func managerBtnTapped() -> UIAction {
        let act = UIAction { [weak self] _ in
            let type = TypeOfAccount.manager.rawValue
            self?.updateAccount(type: type)
            UserDefaults.standard.set(type, forKey: "accountType")
            self?.setupButtons()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
                self?.updateTabBar()
            }
            
        }
        return act
    }
    
    func userBtnTapped() -> UIAction {
        let act = UIAction { [weak self] _ in
            let type = TypeOfAccount.user.rawValue
            self?.updateAccount(type: type)
            UserDefaults.standard.set("User", forKey: "accountType")
            self?.setupButtons()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
                self?.updateTabBar()
            }
        }
        return act
    }
    
    //MARK: - Set up view
    func setUpView() {
        view.backgroundColor = .white
        
        view.addSubview(managerButton.0)
        view.addSubview(managerButton.1)
        view.addSubview(managerButton.2)
        
        view.addSubview(userButton.0)
        view.addSubview(userButton.1)
        view.addSubview(userButton.2)
        view.sendSubviewToBack(userButton.2)
        
    }
    
    //MARK: - Set constraint
    func setConstraint() {
        NSLayoutConstraint.activate([
            
            managerButton.0.heightAnchor.constraint(equalToConstant: 56),
            managerButton.0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            managerButton.0.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            managerButton.0.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            managerButton.1.topAnchor.constraint(equalTo: managerButton.0.topAnchor, constant: 20),
            managerButton.1.leadingAnchor.constraint(equalTo: managerButton.0.leadingAnchor, constant: 20),
            managerButton.2.topAnchor.constraint(equalTo: managerButton.0.topAnchor, constant: 15.5),
            managerButton.2.trailingAnchor.constraint(equalTo: managerButton.0.trailingAnchor, constant: -35),
            
            userButton.0.heightAnchor.constraint(equalToConstant: 56),
            userButton.0.topAnchor.constraint(equalTo: managerButton.0.bottomAnchor, constant: 20),
            userButton.0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userButton.0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            userButton.1.topAnchor.constraint(equalTo: userButton.0.topAnchor, constant: 20),
            userButton.1.leadingAnchor.constraint(equalTo: userButton.0.leadingAnchor, constant: 20),
            userButton.2.topAnchor.constraint(equalTo: userButton.0.topAnchor, constant: 15.5),
            userButton.2.trailingAnchor.constraint(equalTo: userButton.0.trailingAnchor, constant: -35),
            
        ])
    }
}

