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
    
    private lazy var typeOfAccountButton: UIButton = {
        let button = ChevronButtonFactory(
            title: "Type of account",
            chevron: "chevron.forward",
            action: UIAction { [weak self] _ in
                let vc = TypeAccountViewController()
                vc.completion = { [weak self] text in
                    self?.viewModel.type? = text
                    self?.checkFormStatus()
//                    self?.typeOfAccountButton.1.text = text
                }
                self?.navigationController?.pushViewController(vc, animated: true)
            },
            textColor: Colors.gray
        )
        return button.createButtonWithChevron()
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
        $0.distribution = .fillEqually
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
                    message: error.localizedDescription) { [weak self] in
                        self?.registerUser()
                    }
            } else {
                self?.coordinator?.finish()
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        navigationItem.title = "Complete your account"
        navigationItem.hidesBackButton = true
        
        view.addSubview(accountStackView)
  
        
        [   loginView,
            emailView,
            passwordView,
            confirmPasswordView,
            typeOfAccountButton,
            signUpButton,
            alreadyHaveAccountButton
        ].forEach(accountStackView.addArrangedSubview(_:))
        
        emailView.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordView.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        confirmPasswordView.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        loginView.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func setConstraints() {
        accountStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(150)
            $0.leading.trailing.equalToSuperview().inset(20)

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
