//
//  ProductListView.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 21.04.2024.
//

import UIKit

final class ProductListView: UIView {
    //MARK: - Private Methods
    
    private let productContainerView = UIView()
    private lazy var productNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Air pods pro max by Apple"
        $0.font = .makeTypography(.medium, size: 16)
        $0.textColor = Colors.darkArsenic
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    private lazy var productPriceLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "$ 1999,99"
        $0.font = .makeTypography(.medium, size: 18)
        $0.textColor = Colors.darkArsenic
        return $0
    }(UILabel())
    
    private lazy var productLabelsStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = 6
        $0.alignment = .leading
        $0.axis = .vertical
        return $0
    }(UIStackView())
    
    lazy var addToWishListButton: UIButton = {

        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 23
        $0.backgroundColor = Colors.gray.withAlphaComponent(0.1)
        $0.setImage(UIImage(named: "Wishlist"), for: .normal)
      
        return $0
    }(UIButton(type: .system))
    
    private lazy var productDescriptionTitleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Description of product"
        $0.font = .makeTypography(.medium, size: 16)
        $0.textColor = Colors.darkArsenic
        return $0
    }(UILabel())
    
    private lazy var productDescriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .makeTypography(.light, size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = Colors.darkArsenic
        return $0
    }(UILabel())
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    private func setupViews() {
        addSubview(productContainerView)
        productContainerView.translatesAutoresizingMaskIntoConstraints = false
        [
            productNameLabel,
            productPriceLabel
        ].forEach(productLabelsStackView.addArrangedSubview(_:))
        
        [
            productLabelsStackView,
            addToWishListButton,
            productDescriptionTitleLabel,
            productDescriptionLabel
        ].forEach(productContainerView.addSubview(_:))
    }
    
    private func setConstraints() {
        productContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        productLabelsStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(addToWishListButton.snp.leading).inset(-8)
        }
        
        addToWishListButton.snp.makeConstraints {
            $0.height.width.equalTo(46)
            $0.centerY.equalTo(productLabelsStackView.snp.centerY)
            $0.trailing.equalTo(productContainerView.snp.trailing).offset(-20)
        }
        
        productDescriptionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(productLabelsStackView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        productDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(productDescriptionTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Public Methods
    func setProduct(name: String) {
        productNameLabel.text = name
    }
    
    func setProduct(price: String) {
        productPriceLabel.text = price
    }
    
    func setProductDescription(text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        productDescriptionLabel.attributedText = attributedString
    }
}

