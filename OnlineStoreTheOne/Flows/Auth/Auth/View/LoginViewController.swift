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
    // MARK: - Private Properties
    private var viewModel: LoginViewModelProtocol
    private var isKeyboardShow = false

    // MARK: - UI Elements
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Resources.Image.logo
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let emailView = InputContainerView(
        image: Resources.Image.mail,
        textField: CustomTextField(
            placeholder: Resources.Text.email,
            type: .text
        )
    )
    
    private let passwordView = InputContainerView(
        image: Resources.Image.lock,
        textField: CustomTextField(
            placeholder: Resources.Text.password,
            type: .password
        )
    )
    
    private lazy var loginButton: UIButton = {
        let button = FilledButtonFactory(
            title: Resources.Text.login,
            type: .greenButton,
            action: UIAction { [weak self] _ in
                self?.loginUser()
            }
        ).createButton()
        return button
    }()
    
    private lazy var loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.loginStackViewSpacing
        return stackView
    }()
    
    private lazy var dontHaveAccountButton: UIButton = {
        let attributedTitle = NSMutableAttributedString(
            string: Resources.Text.dontHaveAccount,
            attributes: [.font: UIFont.makeTypography(.medium, size: Constants.fontSize), .foregroundColor: Colors.darkArsenic]
        )
        attributedTitle.append(
            NSAttributedString(
                string: Resources.Text.signUp,
                attributes: [.font: UIFont.makeTypography(.bold, size: Constants.fontSize), .foregroundColor: Colors.greenSheen]
            )
        )
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
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
    
    deinit {
        stopKeyboardListener()
    }
    
    private func loginUser() {
        viewModel.logUserIn { [weak self] error in
            if let error = error {
                self?.viewModel.showErrorInfo(
                    message: error.localizedDescription) { [weak self] in
                        self?.loginUser()
                    }
            } else {
                self?.viewModel.coordinatorDidFinish()
            }
        }
    }
    
    // MARK: - @Objc Private Methods
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
    
    // MARK: - Private Methods
    private func setupViews() {
        view.backgroundColor = .white
        [logoImageView, loginStackView].forEach { view.addSubview($0) }
        [emailView, passwordView, loginButton, dontHaveAccountButton].forEach { loginStackView.addArrangedSubview($0) }
        
        emailView.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordView.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func setConstraints() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(Constants.logoTopInset)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(Constants.logoSize)
        }
        
        loginStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.loginStackViewTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Constants.loginStackViewHorizontalInset)
        }
    }
}

// MARK: - LoginViewController: AuthenticationControllerProtocol
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

// MARK: - Observers
private extension LoginViewController {
    func setupObservers() {
        startKeyboardListener()
    }
    
    func startKeyboardListener() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    func stopKeyboardListener() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[
            UIResponder.keyboardFrameEndUserInfoKey
        ] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        if !isKeyboardShow {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.logoImageView.isHidden = true
                self.loginStackView.snp.updateConstraints {
                    $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(Constants.logoTopInset)
                }
                self.view.layoutIfNeeded()
                self.isKeyboardShow = true
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard notification.userInfo?[
            UIResponder.keyboardFrameEndUserInfoKey
        ] as? NSValue != nil else { return }
        
        if isKeyboardShow {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.logoImageView.isHidden = false
                self.loginStackView.snp.updateConstraints {
                    $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(Constants.loginStackViewTopOffset)
                }
                self.view.layoutIfNeeded()
                self.isKeyboardShow = false
            }
        }
    }
}

// MARK: - Constants
private extension LoginViewController {
    enum Constants {
        static let logoTopInset: CGFloat = 40
        static let logoSize: CGFloat = 150
        static let loginStackViewTopOffset: CGFloat = 230
        static let loginStackViewHorizontalInset: CGFloat = 20
        static let loginStackViewSpacing: CGFloat = 36
        static let fontSize: CGFloat = 16
    }
}
