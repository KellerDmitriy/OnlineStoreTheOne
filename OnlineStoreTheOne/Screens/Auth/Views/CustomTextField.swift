//
//  CustomTextField.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 23.04.2024.
//

import UIKit

enum CustomTextFieldType {
    case text
    case password
}

final class CustomTextField: UITextField, UITextFieldDelegate {
    
    var textChanged: ((String?) -> Void)?
    var fieldType: CustomTextFieldType

    
    private let passwordToggleButton: UIButton = {
        $0.setImage(UIImage(named: "securityEye"), for: .normal)
        return $0
    }(UIButton())
    init(placeholder: String, type: CustomTextFieldType) {
        self.fieldType = type
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.snp.makeConstraints {
            $0.height.equalTo(46)
            $0.width.equalTo(50)
        }
        
        leftView = spacer
        leftViewMode = .always
        borderStyle = .none
        font = .systemFont(ofSize: 16, weight: .medium)
        textColor = Colors.gray
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: Colors.gray])
        backgroundColor = .clear
        layer.cornerRadius = 8
        self.snp.makeConstraints {
            $0.height.equalTo(46)
        }
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let rightView = self.rightView {
            rightView.frame = CGRect(
                x: self.frame.width - rightView.frame.width - 20,
                y: rightView.frame.origin.y,
                width: rightView.frame.width,
                height: rightView.frame.height
            )
        }
    }
    
    private func commonInit() {
        delegate = self
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        configureForType()
    }
    
    private func configureForType() {
        switch fieldType {
        case .text:
            isSecureTextEntry = false
            passwordToggleButton.removeFromSuperview()
        case .password:
            isSecureTextEntry = true
            addPasswordToggleButton()
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
           var rect = super.textRect(forBounds: bounds)
           if let rv = rightView, rightViewMode != .never {
               rect.size.width -= rv.frame.width + 6
           }
           return rect
       }

       override func editingRect(forBounds bounds: CGRect) -> CGRect {
           var rect = super.editingRect(forBounds: bounds)
           if let rv = rightView, rightViewMode != .never {
               rect.size.width -= rv.frame.width + 6
           }
           return rect
       }
    
    private func addPasswordToggleButton() {
        passwordToggleButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        rightView = passwordToggleButton
        rightViewMode = .whileEditing
    }
    
    @objc private func togglePasswordView() {
        isSecureTextEntry.toggle()
        passwordToggleButton.isSelected.toggle()
    }
    
    @objc private func textFieldDidChange() {
        textChanged?(self.text)
        passwordToggleButton.isHidden = self.text?.isEmpty ?? false
    }
}
