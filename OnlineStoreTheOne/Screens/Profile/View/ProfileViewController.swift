//
//  ProfileScreen.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 15.04.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    var viewModel = ProfileViewModel()
    //MARK: - UI elements
    private lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "ProfileImage")
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 50
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(primaryAction: editImageAction())
        button.setBackgroundImage(UIImage(named: "EditIcon"), for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = false
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    
    private let userName = NewLabelFactory(text: "DevP", font: .bold, size: 16).createLabel()
    
    private lazy var userMail: UILabel = {
        let label = NewLabelFactory(text: "dev@gmail.com", font: .light, size: 14).createLabel()
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: label.text ?? "", attributes: underlineAttribute)
        label.attributedText = underlineAttributedString
        return label
    }()
    
    private lazy var termsButton: UIView = {
        let button = ButtonLabelFactory(title: "Terms & Conditions", type: .standartButton, name: "ArrowIcon", homeView: view, action: termsAction(), textColor: nil).createButtonWithLabel()
        return button
    }()
    
    private lazy var typeButton: UIView = {
        let button = ButtonLabelFactory(
            title: "Type of account",
            type: .standartButton,
            name: "ArrowIcon",
            homeView: view,
            action: action(),
            textColor: nil)
            .createButtonWithLabel()
        return button
    }()
    
    private lazy var signOutButton: UIView = {
        let button = ButtonLabelFactory(
            title: "Sign Out",
            type: .standartButton,
            name: "SignOutIcon",
            homeView: view,
            action: UIAction { [weak self] _ in
                self?.signOutAction()
            },
            textColor: nil)
            .createButtonWithLabel()
        return button
    }()

    private lazy var btnStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 25
        stack.addArrangedSubview(termsButton)
        stack.addArrangedSubview(typeButton)
        stack.addArrangedSubview(signOutButton)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpView()
        setConstraint()
    }
    
    //MARK: - Actions
    func termsAction() -> UIAction {
        let act = UIAction { _ in
            let vc = TermsConditionalsScreen()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return act
    }
    //спросить про переход))))))
    func signOutAction()  {
        viewModel.storageService.onboardingOn()
       let onboarding = OnboardingViewController()
       if let window = view.window {
           window.rootViewController = onboarding
           UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {},
            completion: nil
           )
       }
    }
    
    func editImageAction() -> UIAction {
        let act = UIAction { _ in
            let vc = EditImageScreen()
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
        return act
    }
    
    func action() -> UIAction {
        let action = UIAction { _ in
            print("Profile")
        }
        return action
    }
}

//MARK: - Extension
private extension ProfileViewController {
    
    //MARK: - Set up view
    func setUpView() {
        view.backgroundColor = .white
        
        view.addSubview(profileImage)
        view.addSubview(editButton)
        view.addSubview(userName)
        view.addSubview(userMail)
        view.addSubview(btnStack)
     
    }
    //MARK: - Set constraint
    func setConstraint() {
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 113),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            
            editButton.heightAnchor.constraint(equalToConstant: 32),
            editButton.widthAnchor.constraint(equalToConstant: 32),
            editButton.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 68),
            editButton.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: 68),
            
            userName.topAnchor.constraint(equalTo: view.topAnchor, constant: 127),
            userName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 40),
            
            userMail.topAnchor.constraint(equalTo: userName.topAnchor, constant: 25),
            userMail.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 40),
            
            btnStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            btnStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            btnStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
    }
}


