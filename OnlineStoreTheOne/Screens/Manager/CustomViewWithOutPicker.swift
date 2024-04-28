//
//  CustomViewWithOutPicker.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 27.04.2024.
//

import UIKit

final class CustomViewWithOutPicker: UIView {
    
    private let containerView = UIView()
    private let stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView())
    private lazy var label: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .makeTypography(.semiBold, size: 13)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var textField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.borderStyle = .roundedRect
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Colors.placeholderManagerFields.cgColor
        $0.clearButtonMode = .whileEditing
        return $0
    }(UITextField())
    
    init(with text: String) {
        super.init(frame: .zero)
        self.label.text = text
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        [label, textField].forEach(stackView.addArrangedSubview(_:))
    }
    
    private func setConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(246)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
    }
}