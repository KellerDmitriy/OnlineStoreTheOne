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
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = Colors.lightGray.cgColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var checkMarkButton = CheckMarkButton()
    
    private let productImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var counterActionButton: CounterActionButton = {
        let button = CounterActionButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        selectionStyle = .none
        backgroundColor = .gray
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func configureCell(_ cartModel: CartsModel, 
                       onTrashTapped: @escaping () -> (),
     countDidChange: @escaping ((Int) -> Void))
    {
        titleLabel.text = cartModel.title
        priceLabel.text = String("$\(cartModel.price)")
        
        if let imageData = cartModel.images.first {
            productImageView.image = UIImage(data: imageData)
        } else {
            productImageView.image = UIImage(named: "ps4")
        }
        
        counterActionButton.count = cartModel.countProduct
        checkMarkButton.isChecked = cartModel.isSelected
        
        counterActionButton.onTrashTapped = onTrashTapped
        counterActionButton.countDidChange = countDidChange
    }
    
    //MARK: - Setup Views
    private func setupViews() {
        
        contentView.backgroundColor = .white
        contentView.addSubview(cartsContentView)
        cartsContentView.addSubview(checkMarkButton)
        cartsContentView.addSubview(productImageView)
        cartsContentView.addSubview(titleLabel)
        cartsContentView.addSubview(priceLabel)
        cartsContentView.addSubview(counterActionButton)
    }
    
    private func setConstraints() {
        cartsContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: Constants.verticalSpacing, left: Constants.horizontalSpacing, bottom: Constants.verticalSpacing, right: Constants.horizontalSpacing))
        }
        
        checkMarkButton.snp.makeConstraints { make in
            make.centerY.equalTo(productImageView.snp.centerY)
            make.leading.equalTo(cartsContentView.snp.leadingMargin)
            make.trailing.equalTo(productImageView.snp.leading).offset(-Constants.horizontalSpacing)
        }
        
        productImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(Constants.imageWidth)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.verticalSpacing)
            make.leading.equalTo(productImageView.snp.trailing).offset(Constants.horizontalSpacing)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.labelSpacing)
            make.leading.equalTo(productImageView.snp.trailing).offset(Constants.horizontalSpacing)
        }
        
        counterActionButton.snp.makeConstraints { make in
            make.trailing.equalTo(cartsContentView.snp.trailingMargin)
            make.top.equalTo(priceLabel.snp.bottom).offset(Constants.verticalSpacing)
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
        static let imageWidth: CGFloat = 100
        static let labelSpacing: CGFloat = 10
        static let buttonWidth: CGFloat = 120
        static let buttonHeight: CGFloat = 50
    }
}
