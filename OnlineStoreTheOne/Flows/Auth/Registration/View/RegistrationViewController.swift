//
//  RegistrationViewController.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 23.04.2024.
//

import UIKit

final class RegistrationViewController: UIViewController {
    // MARK: - Private properties
    private var viewModel: RegistrationViewModelProtocol
    private var isKeyboardShow = false
    
    // MARK: - UI Elements
    private let loginView = InputContainerView(
        image: Resources.Image.person,
        textField: CustomTextField(placeholder: Resources.Text.enterName, type: .text)
    )
    
    private let emailView = InputContainerView(
        image: Resources.Image.mail,
        textField: CustomTextField(placeholder: Resources.Text.enterEmail, type: .text)
    )
    
    private let passwordView = InputContainerView(
        image: Resources.Image.lock,
        textField: CustomTextField(placeholder: Resources.Text.enterPassword, type: .password)
    )
    
    private let confirmPasswordView = InputContainerView(
        image: Resources.Image.lock,
        textField: CustomTextField(placeholder: Resources.Text.confirmPassword, type: .password)
    )
    
    private lazy var typeOfAccountButton: UIButton = {
        let button = ChevronButtonFactory(
            title: Resources.Text.typeOfAccount,
            chevron: Resources.Text.chevronForward,
            action: UIAction { [weak self] _ in
                self?.changeType()
            },
            textColor: Colors.gray
        )
        return button.createButtonWithChevron()
    }()
    
    private lazy var signUpButton = FilledButtonFactory(
        title: Resources.Text.signUp,
        type: .greenButton,
        action: UIAction { [weak self] _ in
            self?.registerUser()
        }
    ).createButton()
    
    private lazy var accountStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = Constants.stackViewSpacing
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private lazy var alreadyHaveAccountButton: UIButton = {
        let attributedTitle = NSMutableAttributedString(
            string: Resources.Text.alreadyHaveAccount,
            attributes: [.font: UIFont.makeTypography(.medium, size: Constants.fontSize), .foregroundColor: Colors.darkArsenic]
        )
        attributedTitle.append(
            NSAttributedString(
                string: Resources.Text.logIn,
                attributes: [.font: UIFont.makeTypography(.bold, size: Constants.fontSize), .foregroundColor: Colors.greenSheen]
            )
        )
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setAttributedTitle(attributedTitle, for: .normal)
        $0.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    // MARK: - Lifecycle
    init(viewModel: RegistrationViewModelProtocol) {
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
        checkFormStatus()
    }
    
    deinit {
        stopKeyboardListener()
    }
    
    // MARK: - Private Methods
    private func registerUser() {
        viewModel.registerUser { [weak self] error in
            if let error = error {
                self?.viewModel.showErrorInfo(
                    message: error.localizedDescription) { [weak self] in
                        self?.registerUser()
                    }
            } else {
                self?.viewModel.coordinatorDidFinish()
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        navigationItem.title = Resources.Text.completeYourAccount
        navigationItem.hidesBackButton = true
        
        view.addSubview(accountStackView)
        
        [
            loginView,
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
            $0.top.equalToSuperview().offset(Constants.stackViewTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Constants.stackViewHorizontalInset)
        }
    }
    
    // MARK: - @Objc Private Methods
    private func changeType() {
        let vc = TypeOfAccountViewController()
        vc.completion = { [weak self] text in
            self?.viewModel.type? = text
            self?.viewModel.type = text
            self?.typeOfAccountButton.setTitle(text, for: .normal)
            self?.checkFormStatus()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func handleShowLogin() {
        viewModel.showLoginFlow()
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

// MARK: - RegistrationViewController: AuthenticationControllerProtocol
extension RegistrationViewController: AuthenticationControllerProtocol {
    func checkFormStatus() {
        if viewModel.formIsValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = Colors.greenSheen
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = Colors.greenSheen.withAlphaComponent(0.6)
        }
    }
}
// MARK: - Observers
private extension RegistrationViewController {
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
        guard notification.userInfo?[
            UIResponder.keyboardFrameEndUserInfoKey
        ] is NSValue else { return }
        
        if !isKeyboardShow {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.navigationController?.isNavigationBarHidden = true
                self.accountStackView.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(Constants.stackViewTopOffsetForKeyboardShow)
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
                self.navigationController?.isNavigationBarHidden = false
                self.accountStackView.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(Constants.stackViewTopOffset)
                }
                self.view.layoutIfNeeded()
                self.isKeyboardShow = false
            }
        }
    }
}
// MARK: - Constants
private extension RegistrationViewController {
    enum Constants {
        static let stackViewTopOffset: CGFloat = 150
        static let stackViewTopOffsetForKeyboardShow: CGFloat = 80
        static let stackViewHorizontalInset: CGFloat = 20
        static let stackViewSpacing: CGFloat = 26
        static let fontSize: CGFloat = 16
    }
}
