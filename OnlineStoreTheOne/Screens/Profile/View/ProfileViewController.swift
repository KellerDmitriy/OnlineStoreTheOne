//
//  ProfileScreen.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 15.04.2024.
//

import UIKit
import FirebaseAuth

final class ProfileViewController: UIViewController {
    
   private var viewModel: ProfileViewModel!
   private  let storageService = StorageService()
    
    //MARK: - UI elements
    var profileImage: UIImageView = {
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
    
    
    private lazy var userName: UILabel = {
        NewLabelFactory(text: "DevP", font: .bold, size: 16).createLabel()
    }()
    
    private lazy var userMail: UILabel = {
        let label = NewLabelFactory(text: "dev@gmail.com", font: .light, size: 14).createLabel()
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: label.text ?? "", attributes: underlineAttribute)
        label.attributedText = underlineAttributedString
        return label
    }()
    
    private lazy var termsButton: (UIButton, UILabel, UIView) = {
        let button = ButtonLabelFactory(
            title: "Terms & Conditions",
            type: .standartButton,
            name: "ArrowIcon",
            action: termsAction(),
            textColor: nil)
            .createButtonWithLabel()
        return button
    }()
    
    private lazy var typeButton: (UIButton, UILabel, UIView) = {
        let button = ButtonLabelFactory(
            title: "Type of account",
            type: .standartButton,
            name: "ArrowIcon",
            action: typeAction(),
            textColor: nil)
            .createButtonWithLabel()
        return button
    }()
    
    private lazy var signOutButton: (UIButton, UILabel, UIView) = {
        let button = ButtonLabelFactory(
            title: "Sign Out",
            type: .standartButton,
            name: "SignOutIcon",
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
        stack.addArrangedSubview(termsButton.0)
        stack.addArrangedSubview(typeButton.0)
        stack.addArrangedSubview(signOutButton.0)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        let storageService = StorageService()
        
        viewModel = ProfileViewModel(storageService: storageService)
        
        
        setUpView()
        setConstraint()
        
        navigationItem.title = "Profile"
        navigationController?.setupNavigationBar()
        navigationController?.navigationBar.addBottomBorder()
        
        fetchUser()
    }
    
    
    //MARK: - Actions
    func termsAction() -> UIAction {
        let act = UIAction { _ in
            let vc = TermsConditionalViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return act
    }
    
    func signOutAction() {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sign out", style: .destructive) { _ in
            self.viewModel.storageService.onboardingOn()
            let onboarding = OnboardingViewController(storageService: self.viewModel.storageService)
            if let window = self.view.window {
                window.rootViewController = onboarding
                UIView.transition(
                    with: window,
                    duration: 0.3,
                    options: .transitionCrossDissolve,
                    animations: {},
                    completion: nil
                )
            }
            
            do {
                try Auth.auth().signOut()
            } catch let error {
                print(error.localizedDescription)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func editImageAction() -> UIAction {
        let act = UIAction { _ in
            let vc = EditImageViewController()
            vc.completion = { [ weak self] image in
                self?.profileImage.image = image
            }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
        return act
    }
    
    func typeAction() -> UIAction {
        let act = UIAction { _ in
            let vc = TypeOfAccountViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return act
    }
    
     //MARK: - Private Methods
    private func fetchUser() {
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            
            AuthService.shared.fetchUser(userId: userId) { [weak self] user in
                guard let user, let self else { return }
                userName.text = user.login
                userMail.text = user.email

                if user.profileImageURL.isEmpty {
                    profileImage.image = UIImage(named: "ProfileImage")
                } else {
                    profileImage.kf.setImage(with: URL(string: user.profileImageURL))
                }
            }
        }
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
        view.addSubview(termsButton.1)
        view.addSubview(termsButton.2)
        view.addSubview(typeButton.1)
        view.addSubview(typeButton.2)
        view.addSubview(signOutButton.1)
        view.addSubview(signOutButton.2)
        
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
            
            termsButton.1.topAnchor.constraint(equalTo: termsButton.0.topAnchor, constant: 20),
            termsButton.1.leadingAnchor.constraint(equalTo: termsButton.0.leadingAnchor, constant: 20),
            termsButton.2.topAnchor.constraint(equalTo: termsButton.0.topAnchor, constant: 15.5),
            termsButton.2.trailingAnchor.constraint(equalTo: termsButton.0.trailingAnchor, constant: -35),
            
            typeButton.1.topAnchor.constraint(equalTo: typeButton.0.topAnchor, constant: 20),
            typeButton.1.leadingAnchor.constraint(equalTo: typeButton.0.leadingAnchor, constant: 20),
            typeButton.2.topAnchor.constraint(equalTo: typeButton.0.topAnchor, constant: 15.5),
            typeButton.2.trailingAnchor.constraint(equalTo: typeButton.0.trailingAnchor, constant: -35),
            
            signOutButton.1.topAnchor.constraint(equalTo: signOutButton.0.topAnchor, constant: 20),
            signOutButton.1.leadingAnchor.constraint(equalTo: signOutButton.0.leadingAnchor, constant: 20),
            signOutButton.2.topAnchor.constraint(equalTo: signOutButton.0.topAnchor, constant: 15.5),
            signOutButton.2.trailingAnchor.constraint(equalTo: signOutButton.0.trailingAnchor, constant: -35),
        ])
    }
}


