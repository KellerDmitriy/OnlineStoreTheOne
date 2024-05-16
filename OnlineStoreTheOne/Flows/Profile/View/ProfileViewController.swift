//
//  ProfileScreen.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 15.04.2024.
//

import UIKit
import FirebaseAuth
import SnapKit

final class ProfileViewController: UIViewController {
    
    private var viewModel: ProfileViewModel
    private let coordinator: IProfileCoordinator
    
    
    //MARK: - UI elements
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let settingsView = EditImageView()
    
    lazy var profileImage: UIImageView = {
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
        let button = UIButton(primaryAction: UIAction { [weak self] _ in
            self?.editImageAction()
        })
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
        LabelFactory(text: "DevP", font: .bold, size: 16).createLabel()
    }()
    
    private lazy var userMail: UILabel = {
        let label = LabelFactory(text: "dev@gmail.com", font: .light, size: 14).createLabel()
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: label.text ?? "", attributes: underlineAttribute)
        label.attributedText = underlineAttributedString
        return label
    }()
    
    private lazy var termsButton: UIButton = {
        let button = ChevronButtonFactory(
            title: "Terms & Conditions",
            chevron: "chevron.forward",
            action: UIAction { [weak self] _ in
                self?.termsAction()
            },
            textColor: Colors.gray
        )
        return button.createButtonWithChevron()
    }()
    
    private lazy var typeButton: UIButton = {
        let button = ChevronButtonFactory(
            title: "Type of account",
            chevron: "chevron.forward",
            action: UIAction { [weak self] _ in
                self?.typeAction()
            },
            textColor: Colors.gray
        )
        return button.createButtonWithChevron()
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = ChevronButtonFactory(
            title: "Sign Out",
            chevron: "arrow.forward.to.line.square",
            action: UIAction { [weak self] _ in
                self?.signOutAction()
            },
            textColor: Colors.gray
        )
        return button.createButtonWithChevron()
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.addArrangedSubview(termsButton)
        stack.addArrangedSubview(typeButton)
        stack.addArrangedSubview(signOutButton)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Init
    init(viewModel: ProfileViewModel, coordinator: IProfileCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setConstraint()
        setupNavigationBar()
        fetchUser()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Profile"
        navigationController?.navigationBar.addBottomBorder()
    }
    
    //MARK: - Actions
    func termsAction() {
        coordinator.showTermAndConditionScene()
    }
    
    func signOutAction() {
        coordinator.showAlertController(title: "Attention", message: "Are you sure you want to sign out?", titleDefaultAction: "Sign out", titleDestructiveAction: "Cancel") { [weak self] in
            self?.singOut()
        }
    }
    
    func singOut() {
        viewModel.storageService.isOnboardComplete = false
        coordinator.showOnboardingFlow()
        
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func typeAction() {
        coordinator.showTypeOfAccountScene()
    }
    
    //MARK: - Private Methods
    private func fetchUser() {
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            let authService: IFirebase = DIService.resolve(forKey: .authService) ?? FirebaseService()
            authService.fetchUser(userId: userId) { [weak self] user in
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
        settingsView.delegate = self
        view.backgroundColor = .white
        
        view.addSubview(profileImage)
        view.addSubview(editButton)
        view.addSubview(userName)
        view.addSubview(userMail)
        view.addSubview(buttonsStack)
    }
    
    //MARK: - Set constraint
    func setConstraint() {
        profileImage.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(100)
            make.top.equalTo(view.snp.top).offset(113)
            make.leading.equalTo(view.snp.leading).offset(27)
        }
        
        editButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(32)
            make.top.equalTo(profileImage.snp.top).offset(68)
            make.leading.equalTo(profileImage.snp.leading).offset(68)
        }
        
        userName.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(127)
            make.leading.equalTo(profileImage.snp.trailing).offset(40)
        }
        
        userMail.snp.makeConstraints { make in
            make.top.equalTo(userName.snp.top).offset(25)
            make.leading.equalTo(profileImage.snp.trailing).offset(40)
        }
        
        buttonsStack.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(200)
        }
    }
}

// MARK: - Protocols for load Image from gallery
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, EditImageViewDelegate {
    
    func setupBlurEffectView() {
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0
        view.addSubview(blurEffectView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideSettings))
        blurEffectView.addGestureRecognizer(tapGesture)
    }
    
    func setupSettingsView() {
        settingsView.frame = CGRect(x: editButton.frame.minX, y: editButton.frame.minY, width: 300, height: 300)
        settingsView.alpha = 0
        settingsView.backgroundColor = .white
        settingsView.layer.cornerRadius = 12
        settingsView.clipsToBounds = true
        view.addSubview(settingsView)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        self.profileImage.image = image
        
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            let authService: IFirebase = DIService.resolve(forKey: .authService) ?? FirebaseService()
            authService.uploadUserImage(userId: userId, image: image)
        }
        
        picker.dismiss(animated: true) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    private func chooseImage(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            self.present(imagePicker, animated: true)
        }
    }
    
    //    MARK: - Action for Edit Image
    func takePhotoButtonTap() {
        chooseImage(source: .camera)
    }
    
    func choosePhotoButtonTap() {
        chooseImage(source: .photoLibrary)
    }
    
    func deletePhotoButtonTap() {
        profileImage.image = UIImage(named: "NoPhoto")
    }
    
    func editImageAction() {
        setupBlurEffectView()
        setupSettingsView()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.blurEffectView.alpha = 1
            self.settingsView.center = self.view.center
            self.settingsView.alpha = 1
        })
    }
    
    @objc func hideSettings() {
            UIView.animate(withDuration: 0.3, animations: {
                self.blurEffectView.alpha = 0
                self.settingsView.frame = CGRect(x: self.editButton.frame.minX, y: self.editButton.frame.minY, width: 300, height: 300)
                self.settingsView.alpha = 0
            }) { _ in
                self.blurEffectView.removeFromSuperview()
                self.settingsView.removeFromSuperview()
            }
        }
    }


