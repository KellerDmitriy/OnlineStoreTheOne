//
//  TypeOfAccountViewController.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 18.04.2024.
//

import UIKit
import FirebaseAuth



final class TypeOfAccountViewController: UIViewController {
    //MARK: - UI elements
    
    private lazy var managerButton: UIButton = {
        let button = ChevronButtonFactory(
            title: "Manager",
            chevron: "CheckIcon",
            action: UIAction { [weak self] _ in
                self?.managerBtnTapped()
            },
            textColor: Colors.gray
        )
        return button.createButtonWithChevron()
    }()
    
    private lazy var userButton: UIButton = {
        let button = ChevronButtonFactory(
            title: "User",
            chevron: "CheckIcon",
            action: UIAction { [weak self] _ in
                self?.userBtnTapped()
            },
            textColor: Colors.gray
        )
        return button.createButtonWithChevron()
    }()

    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 25
        stack.addArrangedSubview(userButton)
        stack.addArrangedSubview(managerButton)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setConstraint()
        navigationItem.title = "Type of Account"
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
                self.managerButton.backgroundColor = Colors.greenSheen
                self.managerButton.tintColor = .white
                
                self.userButton.backgroundColor = Colors.lightGray
                self.userButton.tintColor = Colors.darkArsenic
            case TypeOfAccount.basic.rawValue:
                self.managerButton.backgroundColor = Colors.lightGray
                self.managerButton.tintColor = Colors.darkArsenic
                
                self.userButton.backgroundColor = Colors.greenSheen
                self.userButton.tintColor = .white
            default:
                break
            }
        }
        
    }
    
    private func updateAccount(type: String) {
        if let user = Auth.auth().currentUser {
            let authService: IFirebase = DIService.resolve(forKey: .authService) ?? FirebaseService()
            
            authService.changeAccountType(userId: user.uid, type: type)
        }
    }
    
    //MARK: -  Action
    func managerBtnTapped(){
            let type = TypeOfAccount.manager.rawValue
          updateAccount(type: type)
            UserDefaults.standard.set(type, forKey: "accountType")
            setupButtons()
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
//                self?.updateTabBar()
//            }
    }
    
    func userBtnTapped() {
            let type = TypeOfAccount.basic.rawValue
            updateAccount(type: type)
            UserDefaults.standard.set("User", forKey: "accountType")
            setupButtons()
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
//                self?.updateTabBar()
//            }
    }
    
    //MARK: - Set up view
    func setUpView() {
        view.backgroundColor = .white
        view.addSubview(buttonsStack)
    }
    
    //MARK: - Set constraint
    func setConstraint() {
        buttonsStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        managerButton.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        userButton.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }
}

