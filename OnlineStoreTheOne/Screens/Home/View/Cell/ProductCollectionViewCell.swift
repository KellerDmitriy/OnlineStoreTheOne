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
    var addToWishListCompletion: (() -> Void)?
    
    //MARK: - Private Properties
    private let productImageView: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFill
        element.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]     
        element.layer.cornerRadius = 12
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

    private lazy var addToWishListButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "selectedWishlist") {
            button.setBackgroundImage(image, for: .normal)
        }
        button.addAction(UIAction { [weak self] _ in
            self?.addToWishListCompletion?()
        }, for: .touchUpInside)
        return button
    }()
  
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        layer.cornerRadius = 12
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Methods
    func configureCell(
        image: String,
        title: String,
        price: String,
        addToWishListCompletion: @escaping () -> (),
        addToCartCompletion: @escaping () -> ()
    ) {
        productImageView.kf.setImage(with: URL(string: image))
        titleLabel.text = title
        priceLabel.text = price
        self.addToWishListCompletion = addToWishListCompletion
        self.addToCartCompletion = addToCartCompletion
    }
    
    private func setupView() {
        addSubview(productImageView)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(addToCartButton)
        addSubview(addToWishListButton)
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
        
        addToWishListButton.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(13)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(28)
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview().inset(13)
            make.leading.equalTo(addToWishListButton.snp.trailing).offset(8)
            make.bottom.equalToSuperview().inset(10)
        }
    }

}


