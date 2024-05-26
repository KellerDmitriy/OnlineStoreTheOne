//
//  HeaderProductsView.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 16.04.2024.
//

import UIKit
import SnapKit


protocol HeaderProductsDelegate: AnyObject {
    func choseFiltration(filterType: ProductFilter)
}

final class HeaderProductsView: UICollectionReusableView {
    //MARK: - Properties
    weak var delegate: HeaderProductsDelegate?
    
    private let filters: [ProductFilter] = ProductFilter.allCases
    
    //MARK: -  UI elements
    private let headerLabel: UILabel = {
        let element = UILabel()
        element.textColor = .black
        element.font = UIFont.makeTypography(.semiBold, size: 16)
        return element
    }()
    private lazy var filtersButton: UIButton = {
        let element = UIButton()
        element.setTitle("Filters", for: .normal)
        element.setTitleColor(.black, for: .normal)
        element.setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .normal)
        element.tintColor = .black
        element.titleLabel?.font = UIFont.makeTypography(.regular, size: 12)
        element.contentHorizontalAlignment = .leading
        element.addTarget(self, action: #selector(filtersButtonTapped), for: .touchUpInside)
        element.layer.cornerRadius = 8
        element.layer.borderWidth = 1
        element.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor 
        return element
    }()

    //MARK: - Action
    @objc private func filtersButtonTapped() {
        print("нажата - Filters")
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
    
    private func configureFilterMenu(_ button: UIButton) {
        let menu = UIMenu(title: "Filters", children: createMenuChildren(buttonType: button))
        button.showsMenuAsPrimaryAction = true
        button.menu = menu
    }
    
    private func createMenuChildren(buttonType: UIButton) -> [UIAction]{
        return filters.map { filter in
            UIAction(title: filter.typeFilterLabel, handler: { [unowned self] action in
                delegate?.choseFiltration(filterType: filter)
            })
        }
    }
    
    private func setupView() {
        addSubview(headerLabel)
        addSubview(filtersButton)
        configureFilterMenu(filtersButton)
    }
    
    private func setConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        filtersButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(27)
            make.width.equalTo(78)
            make.trailing.equalToSuperview().offset(-25)
            
        }
    }
}

