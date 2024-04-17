//
//  TextFieldCollectionViewCell.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 16.04.2024.
//

import UIKit
import SnapKit

final class TextFieldCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Private Properties
    private let mainView: UIView = {
        let element = UIView()
        element.backgroundColor = .white
        element.layer.cornerRadius = 12
        element.layer.masksToBounds = true
        element.layer.borderWidth = 1
        element.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        return element
    }()
    private let searchButton: UIButton = {
        let element = UIButton(type: .system)
        element.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        element.tintColor = .systemGray
        return element
    }()
    lazy var searchTextField: UITextField = {
        let element = UITextField()
        element.placeholder = NSLocalizedString("Search here ...", comment: "")
        element.backgroundColor = .clear
        element.textAlignment = .left
        element.font = UIFont.makeTypography(.regular, size: 13)    
        element.autocapitalizationType = .words
        element.returnKeyType = .search
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
    private func setupView() {
        addSubview(mainView)
        mainView.addSubview(searchButton)
        mainView.addSubview(searchTextField)
    }

    private func setConstraints() {
        mainView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        searchButton.snp.makeConstraints { make in
            make.height.leading.equalToSuperview()
            make.width.equalTo(40)
        }
        searchTextField.snp.makeConstraints { make in
            make.height.trailing.equalToSuperview()
            make.leading.equalTo(searchButton.snp.trailing)
        }
    }
    
}
