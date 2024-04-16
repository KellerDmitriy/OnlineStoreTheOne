//
//  ProfileScreen.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 15.04.2024.
//

import UIKit

class ProfileScreen: UIViewController {
    
    var profileImage = CreateImage(name: "ProfileImage")
    var eyeButton = UIButton(primaryAction: passwordAction())
    var userNameText = "dev@gmail.com"
    var userName = createLabel(size: 16, font: "Inter-Bold", text: "Dev P", color: Colors.darkArsenic)
    var userMail = createLabel(size: 14, font: "Inter-Bold", text: "dev@gmail.com", color: Colors.gray)
    var userPassword = createLabel(size: 14, font: "Inter-Bold", text: "*****", color: Colors.gray)
    var termsButton = createButton(action: action())
    var typeButton = createButton(action: action())
    var signOutButton = createButton(action: action())
    
    lazy var passwordStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var textStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var btnStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 25
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setImage()
        setStack()
        setButton()
    }
    
    func setImage() {
        view.addSubview(profileImage)
        profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImage.layer.cornerRadius = 50
        
        profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 113).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27).isActive = true
    }
    
    func setStack() {
        eyeButton.setImage(UIImage(named: "EyeIcon"), for: .normal)
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        eyeButton.tintColor = Colors.gray
        
        eyeButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        eyeButton.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: userMail.text ?? "", attributes: underlineAttribute)
        userMail.attributedText = underlineAttributedString
        
        passwordStack.addArrangedSubview(eyeButton)
        passwordStack.addArrangedSubview(userPassword)
        
        textStack.addArrangedSubview(userName)
        textStack.addArrangedSubview(userMail)
        textStack.addArrangedSubview(passwordStack)
        
        view.addSubview(textStack)
        
        NSLayoutConstraint.activate([
            textStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 126),
            textStack.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 20)
            
        ])
        
        
        
        
        
//        eyeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
//        eyeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 50).isActive = true
//        eyeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
//        eyeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 150).isActive = true
    }
    func setButton() {
        btnStack.addArrangedSubview(typeButton)
        btnStack.addArrangedSubview(termsButton)
        btnStack.addArrangedSubview(signOutButton)
        
        view.addSubview(btnStack)
        
        NSLayoutConstraint.activate([
            btnStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            btnStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            btnStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}
