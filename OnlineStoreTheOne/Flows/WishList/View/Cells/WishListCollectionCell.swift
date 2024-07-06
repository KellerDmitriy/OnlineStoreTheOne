//
//  WishListCollectionCell.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 19.04.2024.
//

import UIKit
import Kingfisher

final class WishListCollectionCell: UICollectionViewCell {
    //MARK: - cellID
    static let cellID = String(describing: WishListCollectionCell.self)
    
    var addToCartCompletion: (() -> Void)?
    var removeFromWishListCompletion: (() -> Void)?
    
    //MARK: - Private Properties
    private let productImageView: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFill
        element.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        element.layer.cornerRadius = Constants.cornerRadius
        element.layer.masksToBounds = true
        return element
    }()
    
    private let titleLabel: UILabel = {
        let element = UILabel()
        element.textColor = .black
        element.font = UIFont.makeTypography(.regular, size: Constants.titleFontSize)
        element.textAlignment = .left
        element.backgroundColor = .clear
        return element
    }()
    
    private let priceLabel: UILabel = {
        let element = UILabel()
        element.textColor = .black
        element.font = UIFont.makeTypography(.semiBold, size: Constants.priceFontSize)
        element.textAlignment = .left
        element.backgroundColor = .clear
        return element
    }()
    
    private lazy var addToCartButton: UIButton = {
        let filledButtonFactory = FilledButtonFactory(
            title: Resources.Text.addToCart,
            type: .greenButton,
            action: UIAction { [weak self] _ in
                self?.addToCartCompletion?()
            }
        )
        return filledButtonFactory.createButton()
    }()
    
    private lazy var removeFromWishListButton: UIButton = {
        let button = UIButton()
        if let image = Resources.Image.selectedWishlist {
            button.setBackgroundImage(image, for: .normal)
        }
        button.addAction(UIAction { [weak self] _ in
            self?.removeFromWishListCompletion?()
        }, for: .touchUpInside)
        return button
    }()
  
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        layer.cornerRadius = Constants.cornerRadius
        setupViews()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configureCell(_ wishModel: Products) {
        titleLabel.text = wishModel.title
        priceLabel.text = String("$\(wishModel.price)")
        
        let trimmed = wishModel.images?.first?
            .data(using: .utf8)
            .flatMap { try? JSONSerialization.jsonObject(with: $0) }
            .flatMap { $0 as? [String] }
            .flatMap(\.first)
            .flatMap(URL.init)
        
        if let trimmedUrl = trimmed {
            productImageView.kf.setImage(with: trimmedUrl)
        } else {
            productImageView.kf.setImage(with: URL(string: wishModel.images?.first ?? ""))
        }
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        addSubview(productImageView)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(addToCartButton)
        addSubview(removeFromWishListButton)
    }
    
    private func setConstraints() {
        productImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.productImageHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(Constants.titleTopOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.sideInset)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.priceTopOffset)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        removeFromWishListButton.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(Constants.buttonTopOffset)
            make.leading.equalToSuperview().inset(Constants.sideInset)
            make.bottom.equalToSuperview().inset(Constants.sideInset)
            make.width.equalTo(Constants.wishListButtonWidth)
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(Constants.buttonTopOffset)
            make.trailing.equalToSuperview().inset(Constants.sideInset)
            make.leading.equalTo(removeFromWishListButton.snp.trailing).offset(Constants.buttonSpacing)
            make.bottom.equalToSuperview().inset(Constants.sideInset)
        }
    }
}

// MARK: - Constants
private extension WishListCollectionCell {
    enum Constants {
        static let cornerRadius: CGFloat = 8
        static let backgroundAlpha: CGFloat = 0.1
        static let productImageHeight: CGFloat = 112
        static let titleFontSize: CGFloat = 12
        static let priceFontSize: CGFloat = 14
        static let titleTopOffset: CGFloat = 13
        static let priceTopOffset: CGFloat = 5
        static let buttonTopOffset: CGFloat = 10
        static let sideInset: CGFloat = 13
        static let wishListButtonWidth: CGFloat = 28
        static let buttonSpacing: CGFloat = 8
    }
}
