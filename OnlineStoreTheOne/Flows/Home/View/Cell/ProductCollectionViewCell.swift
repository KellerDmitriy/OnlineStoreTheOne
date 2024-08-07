//
//  ProductCollectionViewCell.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 15.04.2024.
//

import UIKit
import SnapKit
import Kingfisher

final class ProductCollectionViewCell: UICollectionViewCell {
    
    var addToCartCompletion: (() -> Void)?
    
    //MARK: - Private Properties
    private let productImageView: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFill
        element.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        element.layer.cornerRadius = 8
        element.layer.masksToBounds = true
        return element
    }()
    private let titleLabel: UILabel = {
        let element = UILabel()
        element.textColor = .black
        element.font = UIFont.makeTypography(.regular, size: 12)
        element.textAlignment = .left
        element.backgroundColor = .clear
        return element
    }()
    private let priceLabel: UILabel = {
        let element = UILabel()
        element.textColor = .black
        element.font = UIFont.makeTypography(.semiBold, size: 14)
        element.textAlignment = .left
        element.backgroundColor = .clear
        return element
    }()
    
    private lazy var addToCartButton: UIButton = {
        let filledButtonFactory = FilledButtonFactory(
            title: "Add to cart",
            type: .greenButton,
            action: UIAction { [weak self] _ in
                self?.addToCartCompletion?()
            }
        )
        return filledButtonFactory.createButton()
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        layer.cornerRadius = 8
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        addToCartCompletion = nil
    }
    
    //MARK: - Methods
    func configureCell(
        image: String,
        title: String,
        price: String,
        addToCartCompletion: @escaping () -> ()
    ) {
        let trimmed = image
            .data(using: .utf8)
            .flatMap { try? JSONSerialization.jsonObject(with: $0) }
            .flatMap { $0 as? [String] }
            .flatMap(\.first)
            .flatMap(URL.init)
        
        if let trimmedUrl = trimmed {
            productImageView.kf.setImage(with: trimmedUrl)
        } else {
            productImageView.kf.setImage(with: URL(string: image))
        }
        titleLabel.text = title
        priceLabel.text = price
        self.addToCartCompletion = addToCartCompletion
        startShimmering(duration: 2, repeatCount: 2)
    }
    
    private func setupView() {
        contentView.addSubview(productImageView)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(addToCartButton)
        
      
    }
    
    private func setConstraints() {
        productImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(112)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview().inset(13)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(13)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}


