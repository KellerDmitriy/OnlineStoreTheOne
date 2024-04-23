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
    
    lazy var cartsContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderColor = Colors.lightGray.cgColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let productImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    private lazy var titleLabel: UILabel = {
        NewLabelFactory(text: "", font: .regular, color: .black, size: 14).createLabel()
    }()
    
    private lazy var priceLabel: UILabel = {
        NewLabelFactory(text: "", font: .semiBold, color: .black, size: 14).createLabel()
    }()
    
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        addSubview(cartsContentView)
        cartsContentView.addSubview(productImageView)
        cartsContentView.addSubview(titleLabel)
        cartsContentView.addSubview(priceLabel)
    }
    
    private func setConstraints() {
        cartsContentView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview().inset(Constants.verticalSpacing)
        }
        
        productImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalSpacing)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(Constants.wightImage)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.verticalSpacing)
            make.leading.equalTo(productImageView.snp.trailing).offset(Constants.horizontalSpacing)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.bottomSpacing)
            make.leading.equalTo(productImageView.snp.trailing).offset(Constants.horizontalSpacing)
        }
    }
}

// MARK: - Constants
extension CartsTableViewCell {
    struct Constants {
        static let horizontalSpacing: CGFloat = 8
        static let verticalSpacing: CGFloat = 8
        static let wightImage: CGFloat = 100
        static let bottomSpacing: CGFloat = 40
    }
}
