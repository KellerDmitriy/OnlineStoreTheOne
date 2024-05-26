//
//  CustomNavigationBar.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 24.05.2024.
//

import UIKit
import SnapKit

struct CustomNavigationBarConfiguration {
    var title: String = ""
    var withSearchTextField: Bool = false
    var isSetupBackButton: Bool
    var isSetupCartButton: Bool
}

protocol SetupCustomNavBarProtocol {
    var customNavigationBar: CustomNavigationBar { get set }
}


protocol CustomNavigationBar: CustomNavigationBarProtocol {
    var title: String { get set }
    var backButton: UIButton { get }
    var cartButton: UIButton { get }
    func setupBackButton(_ isSetupBackButton: Bool)
    func setupCartButton(_ isSetupCartButton: Bool)
}


protocol CustomNavigationBarProtocol: AnyObject {
    func setupConfiguration(_ configuration: CustomNavigationBarConfiguration?)
}

final class CustomNavigationBarImpl: UIView, CustomNavigationBar {
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    let backButton: UIButton = BackButton()
    let cartButton: UIButton = CartButton()
   
    let searchTextFieldCell: SearchFieldCollectionViewCell = {
        let cell = SearchFieldCollectionViewCell()
        return cell
    }()
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(_ isSetupCartButton: Bool, _ isSetupBackButton: Bool) {
        addSubview(titleLabel)
        self.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(60)
            make.trailing.equalToSuperview().inset(60)
        }
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func setupBackButton(_ isSetupBackButton: Bool) {
        if isSetupBackButton {
            addSubview(backButton)
            backButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(16)
                make.height.width.equalTo(40)
            }
        }
    }
    
    func setupCartButton(_ isSetupCartsButton: Bool) {
        if isSetupCartsButton {
            addSubview(cartButton)
            cartButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(16)
                make.height.width.equalTo(40)
            }
        }
    }
    
    private func setupButtonOnView(_ button: UIButton, _ inset: Int) {
        addSubview(button)
        
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(inset)
            make.height.width.equalTo(40)
        }
    }
    
    private func setupTextField(
           _ withTextField: Bool,
           _ withCartButton: Bool,
           _ withBackButton: Bool
       ) {
           if withTextField {
               addSubview(searchTextFieldCell)
               searchTextFieldCell.snp.makeConstraints { make in
                   make.top.bottom.equalToSuperview().inset(5)
                   make.trailing.equalToSuperview().inset(57)
                   if withBackButton {
                       make.leading.equalToSuperview().inset(50)
                   } else {
                       make.leading.equalToSuperview().inset(16)
                   }
               }
           }
       }
    

    func setupConfiguration(_ configuration: CustomNavigationBarConfiguration?) {
        guard let configuration else { return }
        
        backgroundColor = .systemBackground
        
        setTitle(title: configuration.title)
        setupView(configuration.isSetupCartButton, configuration.isSetupBackButton)
        setupBackButton(configuration.isSetupBackButton)
        setupCartButton(configuration.isSetupCartButton)
        
        setupTextField(configuration.withSearchTextField,
                       configuration.isSetupCartButton,
                       configuration.isSetupBackButton
        )
    }
}
