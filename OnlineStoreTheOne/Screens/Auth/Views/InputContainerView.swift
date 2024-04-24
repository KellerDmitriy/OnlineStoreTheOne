//
//  InputContainerView.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 23.04.2024.
//

import UIKit

final class InputContainerView: UIView {
    let imageView = UIImageView()
    let textField: CustomTextField
    
    init(image: UIImage?, textField: CustomTextField) {
        self.textField = textField
        super.init(frame: .zero)
        self.snp.makeConstraints {
            $0.height.equalTo(46)
        }
        backgroundColor = Colors.grayBackgroundAuth
        addSubview(textField)
        
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.tintColor = Colors.gray
        imageView.alpha = 0.87
        imageView.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).inset(26)
        }
        textField.textChanged = { [weak self] text in
            let hasText = !(text?.isEmpty ?? true)
            self?.updateAppearance(hasText: hasText)
        }
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = Colors.grayBorderAuth.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAppearance(hasText: Bool) {
        backgroundColor = hasText ? .clear : Colors.grayBackgroundAuth
        layer.borderColor = hasText ? Colors.greenSheen.cgColor : Colors.grayBorderAuth.cgColor
        imageView.tintColor = hasText ? Colors.greenSheen : Colors.gray
    }
}
