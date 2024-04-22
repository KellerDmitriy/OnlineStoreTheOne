//
//  CartsTableViewCell.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 15.04.2024.
//

import UIKit
import Kingfisher

final class CartsTableViewCell: UITableViewCell {
    //MARK: - cellID
    static let cellID = String(describing: CartsTableViewCell.self)
    
    //MARK: - Public Properties
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
    
    //MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: - Methods
    func configureCell(_ cartModel: CartsModel) {
        titleLabel.text = cartModel.title
        priceLabel.text = String("\(cartModel.price)")
        
        if let imageData = cartModel.images.first {
            productImageView.image = UIImage(data: imageData)
        } else {
            productImageView.image = UIImage(named: "ps4")
        }
    }
    
    //MARK: - Setup Views
    private func setupViews() {
        addSubview(productImageView)
        addSubview(titleLabel)
        addSubview(priceLabel)
    }
    
    private func setConstraints() {
        productImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview().inset(13)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(titleLabel)
        }
    }
}
