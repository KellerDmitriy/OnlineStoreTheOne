//
//  LoginViewController.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 23.04.2024.
//

import UIKit

protocol AuthenticationControllerProtocol {
    func checkFormStatus()
}

final class LoginViewController: UIViewController {
    
    private let coordinator: IAuthCoordinator?
    var viewModel: LoginViewModel
    
     //MARK: - Private Properties
    private lazy var logoImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "logo")
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    private let emailView = InputContainerView(
        image: UIImage(named: "mail"),
        textField: CustomTextField(placeholder: "Email", type: .text)
    )
    
    private let passwordView = InputContainerView(
        image: UIImage(named: "lock"),
        textField: CustomTextField(placeholder: "Password", type: .password)
    )
    
    private lazy var loginButton = FilledButtonFactory(
        title: "Log In",
        type: .greenButton,
        action: loginUserAction()
    ).createButton()
    
    private lazy var loginStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 36
        return $0
    }(UIStackView())
    
    private lazy var dontHaveAccountButton: UIButton = {
        let attributedTitle = NSMutableAttributedString(
            string: "Don't have an account? ",
            attributes: [.font: UIFont.makeTypography(.medium, size: 16), .foregroundColor: Colors.darkArsenic]
        )
        attributedTitle.append(
            NSAttributedString(
                string: "Sign Up",
                attributes: [.font: UIFont.makeTypography(.bold, size: 16), .foregroundColor: Colors.greenSheen]
            )
        )
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setAttributedTitle(attributedTitle, for: .normal)
        $0.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))

    
     //MARK: - Lifecycle\
    
    init(coordinator: IAuthCoordinator, viewModel: LoginViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
     //MARK: - Private Methods
    private func setupViews() {
        view.backgroundColor = .white
        [
            logoImageView,
            loginStackView,
            dontHaveAccountButton
        ].forEach(view.addSubview(_:))
        
        [
            emailView,
            passwordView,
            loginButton
        ].forEach(loginStackView.addArrangedSubview(_:))
        
        loginButton.titleLabel?.font = .makeTypography(.bold, size: 18)
        loginButton.layer.cornerRadius = 8
        loginButton.isEnabled = false
        loginButton.backgroundColor = Colors.greenSheen.withAlphaComponent(0.6)
        
        emailView.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordView.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func setConstraints() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(40)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(150)
        }
        
        loginButton.snp.makeConstraints {
            $0.height.equalTo(46)
        }
        
        loginStackView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        dontHaveAccountButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
    }
    
    private func loginUserAction() -> UIAction {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            
            guard
                let email = viewModel.email,
                let password = viewModel.password
            else { return }
            let authService: AuthProvider = DIService.resolve(forKey: .authService) ?? AuthService()
            authService.logUserIn(with: email, password: password) { result, error in
                if let error {
                    print("Error login user: \(error)")
                } else {
                    self.updateTabBar()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        self?.dismiss(animated: true)
                    }
                }
            }
        }
        return action
    }
    
    private func updateTabBar() {
//        NotificationCenter.default.post(name: .updateTabBarVisibility, object: nil)
    }
    
     //MARK: - @Objc Private Methods
    @objc private func handleShowSignUp() {
        coordinator?.showRegistationScene()
    }
    
    @objc private func textDidChange(sender: CustomTextField) {
        if sender == emailView.textField {
            viewModel.email = emailView.textField.text
        } else {
            viewModel.password = passwordView.textField.text
        }
        checkFormStatus()
    }
}

 //MARK: - LoginViewController: AuthenticationControllerProtocol
extension LoginViewController: AuthenticationControllerProtocol {
    func checkFormStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = Colors.greenSheen
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = Colors.greenSheen.withAlphaComponent(0.6)
        }
    }
}
