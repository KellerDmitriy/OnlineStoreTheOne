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
    
    private var viewModel: LoginViewModelProtocol
    
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
        action: UIAction { [weak self] _ in
            self?.loginUser()
        }
    ).createButton()
    
    private lazy var loginStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fillEqually
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
    
    init(viewModel: LoginViewModelProtocol) {
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
        setupObservers()
    }
    
    
    private func loginUser() {
        viewModel.logUserIn { [weak self] error in
            if let error = error {
                self?.viewModel.showErrorInfo(
                    message: error.localizedDescription) { [weak self]  in
                        self?.loginUser()
                    }
            } else {
                self?.viewModel.coordinatorDidFinish()
            }
        }
    }
    
    //MARK: - @Objc Private Methods
    @objc private func handleShowSignUp() {
        viewModel.showRegistationScene()
    }
    
    @objc private func textDidChange(sender: CustomTextField) {
        if sender == emailView.textField {
            viewModel.email = emailView.textField.text
        } else {
            viewModel.password = passwordView.textField.text
        }
        checkFormStatus()
    }
    
    //MARK: - Private Methods
    private func setupViews() {
        view.backgroundColor = .white
        [
            logoImageView,
            loginStackView
            
        ].forEach(view.addSubview(_:))
        
        [
            emailView,
            passwordView,
            loginButton,
            dontHaveAccountButton
        ].forEach(loginStackView.addArrangedSubview(_:))
        
        emailView.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordView.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func setConstraints() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(40)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(150)
        }
        
        loginStackView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
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

//MARK: - Observers
private extension LoginViewController {
    func setupObservers() {
        startKeyboardListener()
    }
    
    func startKeyboardListener() {
        
    }
    
    func storKeyboardListener() {
        
    }
    
    func handleTap() {
        
    }
    
    func keyboardWillShow() {
        
    }
    
    func keyboardWillHide() {
        
    }
}
