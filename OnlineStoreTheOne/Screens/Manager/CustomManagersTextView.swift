//
//  CustomManagersTextView.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 27.04.2024.
//

import UIKit

final class CustomManagersTextView: UIView {
    
    //MARK: - Private Properties
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
    
    private lazy var textView: UITextView = {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Colors.placeholderManagerFields.cgColor
        $0.delegate = self
        $0.font = .makeTypography(.medium, size: 16)
        return $0
    }(UITextView())
    
    //MARK: - Callback
    var textChanged: ((String?) -> Void)?
    
    //MARK: - Lifecycle
    init(with text: String) {
        super.init(frame: .zero)
        self.label.text = text
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    private func setupViews() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        [label, textView].forEach(stackView.addArrangedSubview(_:))
    }
    
    private func setConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textView.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(246)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
    }
}

//MARK: - CustomManagersTextView: UITextViewDelegate
extension CustomManagersTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textView.snp.updateConstraints {
            $0.height.equalTo(max(40, textView.contentHeight))
        }
        
        textChanged?(textView.text)
    }
}

//MARK: - extension UITextView
extension UITextView {
    var contentHeight: CGFloat {
        sizeThatFits(
            CGSize(
                width: bounds.width,
                height: CGFloat.greatestFiniteMagnitude
            )
        ).height
    }
}
