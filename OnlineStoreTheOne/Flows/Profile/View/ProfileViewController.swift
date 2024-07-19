//
//  ProfileScreen.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 15.04.2024.
//

import UIKit
import FirebaseAuth
import SnapKit

final class ProfileViewController: BaseViewController {
    // MARK: - Properties
    private var viewModel: IProfileViewModel
    
    //MARK: - UI elements
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let settingsView = EditImageView()
    
    private let profileInformationContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.image = Resources.Image.profileImage
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = Constants.cornerRadius
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var changeAvatarButton: UIButton = {
        let button = UIButton(primaryAction: UIAction { [weak self] _ in
            self?.editImageAction()
        })
        button.setBackgroundImage(Resources.Image.editIcon, for: .normal)
        button.layer.cornerRadius = Constants.editButtonCornerRadius
        button.layer.masksToBounds = false
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = Constants.borderWidth
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var userName: UILabel = {
        LabelFactory(text: Resources.Texts.userName, font: .bold, size: 16).createLabel()
    }()
    
    private lazy var userMail: UILabel = {
        let label = LabelFactory(text: Resources.Texts.userEmail, font: .light, size: 14).createLabel()
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: label.text ?? "", attributes: underlineAttribute)
        label.attributedText = underlineAttributedString
        return label
    }()
    
    private lazy var termsButton: UIButton = {
        let button = ChevronButtonFactory(
            title: Resources.Texts.termsConditions,
            chevron: Resources.Texts.chevronForward,
            action: UIAction { [weak self] _ in
                self?.viewModel.showTermAndConditionScene()
            },
            textColor: Colors.gray
        )
        return button.createButtonWithChevron()
    }()
    
    private lazy var typeButton: UIButton = {
        let button = ChevronButtonFactory(
            title: Resources.Texts.typeOfAccount,
            chevron: Resources.Texts.chevronForward,
            action: UIAction { [weak self] _ in
                self?.viewModel.showTypeOfAccountScene()
            },
            textColor: Colors.gray
        )
        return button.createButtonWithChevron()
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = ChevronButtonFactory(
            title: Resources.Texts.signOut,
            chevron: Resources.Texts.arrowForward,
            action: UIAction { [weak self] _ in
                self?.viewModel.signOutAction()
            },
            textColor: Colors.gray
        )
        return button.createButtonWithChevron()
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.distribution = .fillEqually
        stack.addArrangedSubview(termsButton)
        stack.addArrangedSubview(typeButton)
        stack.addArrangedSubview(signOutButton)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Init
    init(viewModel: IProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setupConstraints()
        setupNavigationBar()
        fetchUser()
    }
    
    func setupNavigationBar() {
        navigationItem.title = Resources.Texts.profile
        navigationController?.navigationBar.addBottomBorder()
    }
    
    //MARK: - Private Methods
    private func fetchUser() {
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            let authService: IFirebase = DIService.resolve(forKey: .authService) ?? FirebaseService()
            authService.fetchUser(userId: userId) { [weak self] user in
                guard let user, let self else { return }
                self.userName.text = user.login
                self.userMail.text = user.email
                
                if user.profileImageURL.isEmpty {
                    self.profileImage.image = Resources.Image.profileImage
                } else {
                    self.profileImage.kf.setImage(with: URL(string: user.profileImageURL))
                }
            }
        }
    }
    
    override func addViews() {
        settingsView.delegate = self
        
        view.addSubview(profileInformationContainer)
        
        [
            profileImage,
            changeAvatarButton,
            userName,
            userMail
        ].forEach(profileInformationContainer.addSubview(_:))
        
        view.addSubview(buttonsStack)
    }
    
    override func setupConstraints() {
        profileInformationContainer.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(Constants.topOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
            make.height.equalTo(Constants.profileInfoContainerHeight)
        }
        
        profileImage.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.profileImageSize)
            make.top.leading.equalToSuperview()
        }
        
        changeAvatarButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.editButtonSize)
            make.top.equalTo(profileImage.snp.top).offset(Constants.editButtonOffset)
            make.leading.equalTo(profileImage.snp.leading).offset(Constants.editButtonOffset)
        }
        
        userName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.userNameTopOffset)
            make.leading.equalTo(profileImage.snp.trailing).offset(Constants.userNameLeadingOffset)
        }
        
        userMail.snp.makeConstraints { make in
            make.top.equalTo(userName.snp.top).offset(Constants.userMailTopOffset)
            make.leading.equalTo(profileImage.snp.trailing).offset(Constants.userNameLeadingOffset)
        }
        
        buttonsStack.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(Constants.stackBottomOffset)
            make.leading.equalTo(view.snp.leading).offset(Constants.stackHorizontalInset)
            make.trailing.equalTo(view.snp.trailing).inset(Constants.stackHorizontalInset)
            make.height.equalTo(Constants.stackHeight)
        }
    }
}


// MARK: - Protocols for load Image from gallery
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, EditImageViewDelegate {
    
    func setupBlurEffectView() {
           guard let windowScene = view.window?.windowScene else { return }
           guard let window = windowScene.windows.first else { return }
           
           blurEffectView.frame = window.bounds
           blurEffectView.alpha = 0
           window.addSubview(blurEffectView)
           
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideSettings))
           blurEffectView.addGestureRecognizer(tapGesture)
       }
       
       func setupSettingsView() {
           guard let windowScene = view.window?.windowScene else { return }
           guard let window = windowScene.windows.first else { return }
           
           settingsView.frame = CGRect(
            x: changeAvatarButton.frame.minX,
            y: changeAvatarButton.frame.minY,
            width: 300,
            height: 300
           )
           settingsView.backgroundColor = .white
           settingsView.layer.cornerRadius = 12
           settingsView.clipsToBounds = true
           window.addSubview(settingsView)
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
        })
    }
    
    @objc func hideSettings() {
        UIView.animate(withDuration: 0.3, animations: {
            self.blurEffectView.alpha = 0
            self.settingsView.frame = CGRect(
                x: self.changeAvatarButton.frame.minX,
                y: self.changeAvatarButton.frame.minY,
                width: 300,
                height: 300
            )
        }) { _ in
            self.blurEffectView.removeFromSuperview()
            self.settingsView.removeFromSuperview()
        }
    }
}

extension ProfileViewController {
    enum Constants {
        static let topOffset: CGFloat = 16
        static let horizontalInset: CGFloat = 16
        static let profileInfoContainerHeight: CGFloat = 120
        static let profileImageSize: CGFloat = 100
        static let editButtonSize: CGFloat = 32
        static let editButtonOffset: CGFloat = 68
        static let cornerRadius: CGFloat = 50
        static let editButtonCornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 3
        static let userNameTopOffset: CGFloat = 16
        static let userNameLeadingOffset: CGFloat = 40
        static let userMailTopOffset: CGFloat = 25
        static let stackSpacing: CGFloat = 16
        static let stackBottomOffset: CGFloat = -30
        static let stackHorizontalInset: CGFloat = 20
        static let stackHeight: CGFloat = 200
    }
}
