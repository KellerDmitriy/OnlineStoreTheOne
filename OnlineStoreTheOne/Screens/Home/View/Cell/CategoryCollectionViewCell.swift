//
//  CategoryCollectionViewCell.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 15.04.2024.
//

import UIKit
import SnapKit
import Kingfisher

final class CategoryCollectionViewCell: UICollectionViewCell {

    //MARK: - Private Properties
    private let categoryImageView: UIImageView = {
        let element = UIImageView()
        element.layer.cornerRadius = 12
        element.layer.masksToBounds = true
        element.contentMode = .scaleAspectFill
        return element
    }()
    private let nameLabel: UILabel = {
        let element = UILabel()
        element.textColor = .systemGray
        element.font = UIFont.makeTypography(.regular, size: 12)
        element.textAlignment = .left
        element.backgroundColor = .clear
        return element
    }()

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
    func configureCell(image: String, category: String) {
//        categoryImageView.image = UIImage(named: image)
        categoryImageView.kf.setImage(with: URL(string: image))
        nameLabel.text = category
    }
    
    private func setupView() {
        addSubview(categoryImageView)
        addSubview(nameLabel)
    }
    
    private func setConstraints() {
        categoryImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(6)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(categoryImageView.snp.bottom).offset(8)
        }
    }

}

