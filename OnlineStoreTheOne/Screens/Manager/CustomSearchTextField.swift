//
//  CustomSearchTextField.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 27.04.2024.
//

import UIKit

final class CustomSearchTextField: UITextField {
    
    private let imageView = UIImageView()
    private let iconContainerView = UIView()
    var textChanged: ((String?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        imageView.image = UIImage(named: "Search")
        imageView.contentMode = .scaleAspectFit
        
        iconContainerView.addSubview(imageView)
        leftView = iconContainerView
        leftViewMode = .always
        
        placeholder = "Search"
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = Colors.placeholderManagerFields.cgColor
        delegate = self
    }
    
    private func setConstraints() {
        snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        iconContainerView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.center.equalToSuperview()
        }
    }
}

extension CustomSearchTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textChanged?(self.text)
        resignFirstResponder()
        return true
    }
}
