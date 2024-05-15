//
//  RegistrationViewController.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 23.04.2024.
//

import UIKit

final class RegistrationViewController: UIViewController {
     //MARK: - Private properties
    
    private let coordinator: IAuthCoordinator?
    private var viewModel: RegistrationViewModelProtocol
    
    private let completeAccountLabel: UILabel = {
        $0.text = "Complete your account"
        $0.font = .makeTypography(.bold, size: 24)
        $0.textColor = Colors.darkArsenic
        return $0
    }(UILabel())
    
    private let labelsStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alignment = .center
        $0.spacing = 42
        $0.axis = .vertical
        return $0
    }(UIStackView())
    
    private let loginView = InputContainerView(
        image: UIImage(named: "person"),
        textField: CustomTextField(placeholder: "Enter your Name", type: .text)
    )
    
    private let emailView = InputContainerView(
        image: UIImage(named: "mail"),
        textField: CustomTextField(placeholder: "Enter your Email", type: .text)
    )
    
    private let passwordView = InputContainerView(
        image: UIImage(named: "lock"),
        textField: CustomTextField(placeholder: "Enter your Password", type: .password)
    )
    
    private let confirmPasswordView = InputContainerView(
        image: UIImage(named: "lock"),
        textField: CustomTextField(placeholder: "Confirm your Password", type: .password)
    )
    
    private lazy var typeOfAccountButton: (UIButton, UILabel, UIView) = {
        let button = ButtonLabelFactory(
            title: "Type of account",
            type: .standartButton,
            name: "ArrowIcon",
            action: UIAction(handler: { [weak self] _ in
                let vc = TypeAccountViewController()
                vc.completion = { [weak self] text in
                    self?.viewModel.type? = text
                    self?.checkFormStatus()
                    self?.typeOfAccountButton.1.text = text
                }
                self?.navigationController?.pushViewController(vc, animated: true)
            }),
            textColor: nil)
            .createButtonWithLabel()
        button.0.backgroundColor = Colors.grayBackgroundAuth
        button.0.layer.borderWidth = 1
        button.0.layer.borderColor = Colors.grayBorderAuth.cgColor
        button.1.textColor = Colors.gray
        button.1.font = .makeTypography(.medium, size: 16)
        return button
    }()
    
    private lazy var signUpButton = FilledButtonFactory(
        title: "Sign Up",
        type: .greenButton,
        action: UIAction { [weak self] _ in
            self?.registerUser()
        }
    ).createButton()
    
    private lazy var accountStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 26
        return $0
    }(UIStackView())
    
    private lazy var alreadyHaveAccountButton: UIButton = {
        let attributedTitle = NSMutableAttributedString(
            string: "Already have an account? ",
            attributes: [.font: UIFont.makeTypography(.medium, size: 16), .foregroundColor: Colors.darkArsenic]
        )
        attributedTitle.append(
            NSAttributedString(
                string: "Log In",
                attributes: [.font: UIFont.makeTypography(.bold, size: 16), .foregroundColor: Colors.greenSheen]
            )
        )
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setAttributedTitle(attributedTitle, for: .normal)
        $0.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    

    
     //MARK: - Lifecycle
    
    init(coordinator: IAuthCoordinator, viewModel: RegistrationViewModelProtocol) {
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
    private func registerUser() {
        viewModel.registerUser { [weak self] error in
            if let error = error {
                self?.coordinator?.showAlertController(
                    title: "Error",
                    message: error.localizedDescription) { [weak self] _ in
                        self?.registerUser()
                    }
            } else {
                self?.coordinator?.finish()
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        
        signUpButton.titleLabel?.font = .makeTypography(.bold, size: 18)
        signUpButton.layer.cornerRadius = 8
        signUpButton.isEnabled = false
        signUpButton.backgroundColor = Colors.greenSheen.withAlphaComponent(0.6)
        [
            labelsStackView,
            accountStackView,
            alreadyHaveAccountButton
        ].forEach(view.addSubview(_:))
        
        [
            completeAccountLabel
        ].forEach(labelsStackView.addArrangedSubview(_:))
        
        [
            loginView,
            emailView,
            passwordView,
            confirmPasswordView,
            typeOfAccountButton.0,
            signUpButton
        ].forEach(accountStackView.addArrangedSubview(_:))
        typeOfAccountButton.0.addSubview(typeOfAccountButton.1)
        typeOfAccountButton.0.addSubview(typeOfAccountButton.2)
        
        emailView.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordView.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        confirmPasswordView.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        loginView.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func setConstraints() {
        labelsStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        accountStackView.snp.makeConstraints {
            $0.top.equalTo(labelsStackView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        signUpButton.snp.makeConstraints {
            $0.height.equalTo(46)
        }
        
        alreadyHaveAccountButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        typeOfAccountButton.0.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        typeOfAccountButton.1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(20)
        }
        
        typeOfAccountButton.2.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().offset(-40)
        }
    }
    
     //MARK: - @Objc Private Methods
    @objc private func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func textDidChange(sender: CustomTextField) {
        switch sender {
        case emailView.textField:
            viewModel.email = emailView.textField.text
        case loginView.textField:
            viewModel.login = loginView.textField.text
        case passwordView.textField:
            viewModel.password = passwordView.textField.text
        case confirmPasswordView.textField:
            viewModel.confirmPassword = confirmPasswordView.textField.text
        default:
            print("unknown field")
        }
        checkFormStatus()
    }
}

 //MARK: - RegistrationViewController: AuthenticationControllerProtocol
extension RegistrationViewController: AuthenticationControllerProtocol {
    func checkFormStatus() {
        signUpButton.isEnabled = viewModel.formIsValid
        signUpButton.backgroundColor = viewModel.formIsValid ? Colors.greenSheen : Colors.greenSheen.withAlphaComponent(0.6)
    }
}
