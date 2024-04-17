//
//  HeaderNavBarMenuView.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 16.04.2024.
//

import UIKit
import SnapKit

final class HeaderNavBarMenuView: UICollectionReusableView {
    
    //MARK: - Private Properties
    private let headerLabel: UILabel = {
        let element = UILabel()
        element.textColor = .systemGray
        element.font = UIFont.makeTypography(.medium, size: 13)
        return element
    }()
    private let locationLabel: UILabel = {
        let element = UILabel()
        element.textColor = .black
        element.font = UIFont.makeTypography(.medium, size: 14)
        element.text = "Salatiga City, Central Java"
        return element
    }()
    private let chevronImageView: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(systemName: "chevron.down")
        element.contentMode = .scaleAspectFill
        element.tintColor = .black
        return element
    }()
    private lazy var cartButton: UIButton = {
        let element = UIButton()
        element.tintColor = .black
        element.setBackgroundImage(UIImage(systemName: "cart"), for: .normal)
        element.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        return element
    }()
    private lazy var bellButton: UIButton = {
        let element = UIButton()
        element.tintColor = .black
        element.setBackgroundImage(UIImage(systemName: "bell"), for: .normal)
        element.addTarget(self, action: #selector(bellButtonTapped), for: .touchUpInside)
        return element
    }()
    //MARK: - Action
    @objc private func cartButtonTapped() {
        print("нажата - Cart")
    }
    @objc private func bellButtonTapped() {
        print("нажата - Bell")
    }
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Methods
    func configureHeader(labelName: String) {
        headerLabel.text = labelName
    }
    
    private func setupView() {
        addSubview(headerLabel)
        addSubview(cartButton)
        addSubview(bellButton)
        addSubview(locationLabel)
        addSubview(chevronImageView)
    }
    
    private func setConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        cartButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(10)
            make.height.width.equalTo(28)
            make.trailing.equalToSuperview().offset(-60)
        }
        bellButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(10)
            make.height.width.equalTo(28)
            make.trailing.equalToSuperview().offset(-20)
        }
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(5)
            make.leading.equalTo(headerLabel)
        }
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalTo(locationLabel)
            make.leading.equalTo(locationLabel.snp.trailing).offset(5)
            make.height.width.equalTo(12)
        }
    }
}
