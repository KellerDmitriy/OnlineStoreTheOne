//
//  CartsTableViewCell.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 15.04.2024.
//

import UIKit
import SnapKit
import Kingfisher

final class CartsTableViewCell: UITableViewCell {
    //MARK: - cellID
    static let cellID = String(describing: CartsTableViewCell.self)
    
    //MARK: - Private Properties
    private lazy var cartsContentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = Colors.lightGray
        view.makeCellShadow()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var checkMarkButton = CheckMarkButton()
    
    private let productImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var counterActionButton: CounterActionButton = {
        let button = CounterActionButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        LabelFactory(text: "", font: .regular, color: .black, size: 14).createLabel()
    }()
    
    private lazy var priceLabel: UILabel = {
        LabelFactory(text: "", font: .semiBold, color: .black, size: 14).createLabel()
    }()
    
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func configureCell(_ 
                       cartModel: CartModel,
                       onTrashTapped: @escaping () -> Void,
                       countDidChange: @escaping ((Int) -> Void),
                       isChecked: @escaping ((Bool) -> Void)
    )
    {
        titleLabel.text = cartModel.product.title
        priceLabel.text = String("$\(cartModel.product.price)")
        
        let trimmed = cartModel.product.images?.first?
            .data(using: .utf8)
            .flatMap { try? JSONSerialization.jsonObject(with: $0) }
            .flatMap { $0 as? [String] }
            .flatMap(\.first)
            .flatMap(URL.init)
        
        if let trimmedUrl = trimmed {
            productImageView.kf.setImage(with: trimmedUrl)
        } else {
            productImageView.kf.setImage(with: URL(string: cartModel.product.images?.first ?? ""))
        }
        
        counterActionButton.count = cartModel.countProduct
        checkMarkButton.isChecked = cartModel.isSelected
        
        counterActionButton.onTrashTapped = onTrashTapped
        counterActionButton.countDidChange = countDidChange
        checkMarkButton.isCheckedMark = isChecked
    }
    
    //MARK: - Setup Views
    private func setupViews() {
        
        contentView.backgroundColor = .clear
        
        contentView.addSubview(cartsContentView)
        cartsContentView.addSubview(checkMarkButton)
        cartsContentView.addSubview(productImageView)
        cartsContentView.addSubview(titleLabel)
        cartsContentView.addSubview(priceLabel)
        cartsContentView.addSubview(counterActionButton)
    }
    
    private func setConstraints() {
        cartsContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.horizontalSpacing)
        }
        
        checkMarkButton.snp.makeConstraints { make in
            make.centerY.equalTo(productImageView.snp.centerY)
            make.leading.equalToSuperview().offset(Constants.horizontalSpacing)
            make.trailing.equalTo(productImageView.snp.leading).offset(-Constants.horizontalSpacing)
        }
        
        productImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constants.minSpacing)
            make.width.equalTo(Constants.imageWidth)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.verticalSpacing)
            make.leading.equalTo(productImageView.snp.trailing).offset(Constants.horizontalSpacing)
            make.trailing.equalToSuperview().inset(Constants.horizontalSpacing)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.labelSpacing)
            make.leading.equalTo(productImageView.snp.trailing).offset(Constants.horizontalSpacing)
            
        }
        
        counterActionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Constants.minSpacing)
            make.width.equalTo(Constants.buttonWidth)
            make.height.equalTo(Constants.buttonHeight)
        }
    }
}

// MARK: - Constants
extension CartsTableViewCell {
    struct Constants {
        static let horizontalSpacing: CGFloat = 8
        static let verticalSpacing: CGFloat = 8
        static let minSpacing: CGFloat = 4
        static let imageWidth: CGFloat = 100
        static let labelSpacing: CGFloat = 10
        static let buttonWidth: CGFloat = 120
        static let buttonHeight: CGFloat = 30
    }
}
