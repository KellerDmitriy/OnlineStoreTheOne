//
//  WishListCollectionCell.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 19.04.2024.
//

import UIKit

final class WishListCollectionCell: UICollectionViewCell {
    //MARK: - cellID
    static let cellID = String(describing: WishListCollectionCell.self)
    
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
        let element = UIButton()
        element.tintColor = .white
        element.setTitle("Add to cart", for: .normal)
        element.titleLabel?.font = UIFont.makeTypography(.regular, size: 13)
        element.backgroundColor = Colors.greenSheen
        element.layer.cornerRadius = 12
        element.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        return element
    }()
    
    //MARK: - Action
    @objc private func addToCart() {
        
        print("нажата - addToCart")
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        backgroundColor = .white
        backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        layer.cornerRadius = 12
        setupView()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Methods
    func configureCell(_ wishModel: Products) {
        productImageView.image = UIImage(named: wishModel.images?.first ?? "")
        titleLabel.text = wishModel.title
        priceLabel.text = String("\(wishModel.price)")
    }
    
    private func setupView() {
        addSubview(productImageView)
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
