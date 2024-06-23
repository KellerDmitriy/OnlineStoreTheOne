//
//  CustomNavigationBar.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 24.05.2024.
//

import UIKit
import SnapKit

// Конфигурация для настраиваемой навигационной панели
struct CustomNavigationBarConfiguration {
    var title: String = ""
    var withSearchTextField: Bool = false
    var withLocationView: Bool = false
    var isSetupBackButton: Bool = false
    var isSetupCartButton: Bool = false
}

// Протокол для настройки настраиваемой навигационной панели
protocol SetupCustomNavBarProtocol {
    var customNavigationBar: ICustomNavigationBar { get set }
}

// Протокол для настраиваемой навигационной панели
protocol ICustomNavigationBar: CustomNavigationBarProtocol {
    var title: String { get set }
    var backButton: BackButton { get }
    var cartButton: CartButton { get }
    func setupBackButton(_ isSetupBackButton: Bool)
    func setupCartButton(_ isSetupCartButton: Bool)
}

// Протокол для установки конфигурации настраиваемой навигационной панели
protocol CustomNavigationBarProtocol: AnyObject {
    func setupConfiguration(_ configuration: CustomNavigationBarConfiguration?)
}

// Реализация настраиваемой навигационной панели
final class CustomNavigationBarImpl: UIView, ICustomNavigationBar {
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.makeTypography(.semiBold, size: 18)
        label.numberOfLines = 1
        return label
    }()
    
    let backButton = BackButton()
    let cartButton = CartButton()
    
    let locationView = LocationView()
    let searchTextFieldCell = SearchFieldCollectionViewCell()
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleLabel)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(Constants.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.greaterThanOrEqualToSuperview().inset(Constants.titleInset)
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
                make.leading.equalToSuperview().inset(Constants.buttonInset)
                make.height.width.equalTo(Constants.buttonSize)
            }
        }
    }
    
    func setupCartButton(_ isSetupCartButton: Bool) {
        if isSetupCartButton {
            addSubview(cartButton)
            cartButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(Constants.buttonInset)
                make.height.width.equalTo(Constants.buttonSize)
            }
        }
    }
    
    private func setupTextField(_ withTextField: Bool, _ withBackButton: Bool) {
        if withTextField {
            addSubview(searchTextFieldCell.mainView)
            searchTextFieldCell.mainView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(Constants.textFieldVerticalInset)
                make.trailing.equalToSuperview().inset(Constants.textFieldTrailingInset)
                make.leading.equalToSuperview().inset(withBackButton ? Constants.backButtonLeadingInset : Constants.buttonInset)
            }
        }
    }
    
    private func setupLocationView(_ withLocationView: Bool, _ withCartButton: Bool, _ withBackButton: Bool) {
        if withLocationView {
            addSubview(locationView)
            locationView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(Constants.textFieldVerticalInset)
                make.trailing.equalToSuperview().inset(withCartButton ? Constants.locationViewTrailingInsetWithCartButton : Constants.buttonInset)
                make.leading.equalToSuperview().inset(withBackButton ? Constants.backButtonLeadingInset : Constants.buttonInset)
            }
        }
    }

    func setupConfiguration(_ configuration: CustomNavigationBarConfiguration?) {
        guard let configuration = configuration else { return }
        
        backgroundColor = .systemBackground
        
        setTitle(title: configuration.title)
        setupView()
        setupBackButton(configuration.isSetupBackButton)
        setupCartButton(configuration.isSetupCartButton)
        setupTextField(configuration.withSearchTextField, configuration.isSetupBackButton)
        setupLocationView(configuration.withLocationView, configuration.isSetupCartButton, configuration.isSetupBackButton)
    }
    
    
    enum Constants {
        static let height: CGFloat = 44
        static let buttonSize: CGFloat = 40
        static let buttonInset: CGFloat = 10
        static let titleInset: CGFloat = 65
        static let textFieldVerticalInset: CGFloat = 5
        static let textFieldTrailingInset: CGFloat = 57
        static let backButtonLeadingInset: CGFloat = 50
        static let locationViewTrailingInsetWithCartButton: CGFloat = 50
    }
}
