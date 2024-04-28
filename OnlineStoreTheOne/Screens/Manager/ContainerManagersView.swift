//
//  ContainerManagersView.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 27.04.2024.
//

import UIKit

enum ContainerType {
    case addNewProduct, addNewCategory
    case updateProduct, updateCategory
    case deleteProduct, deleteCategory
}

final class ContainerManagersView: UIView {
    
    private let type: ContainerType
    private let containerView = UIView()
    private lazy var stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 20
        return $0
    }(UIStackView())
    
    private let searchField = CustomSearchTextField()
    private let titleField = CustomViewWithOutPicker(with: "Title")
    private let priceField = CustomViewWithOutPicker(with: "Price")
    private let categoryField = CustomViewWithPicker(viewModel: .init(categoryList: []))
    private let descriptionTextView = CustomManagersTextView(with: "Description")
    private let imageOneTextView = CustomManagersTextView(with: "Image 1")
    private let imageTwoTextView = CustomManagersTextView(with: "Image 2")
    private let imageThreeTextView = CustomManagersTextView(with: "Image 3")
    
    init(type: ContainerType) {
        self.type = type
        super.init(frame: .zero)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        switch type {
        case .addNewProduct:
            searchField.isHidden.toggle()
        case .addNewCategory:
            [searchField, priceField,
             categoryField, descriptionTextView,
             imageTwoTextView, imageThreeTextView
            ].forEach { $0.isHidden.toggle() }
        case .updateProduct:
            [categoryField, descriptionTextView,
            imageOneTextView, imageTwoTextView,
            imageThreeTextView
            ].forEach { $0.isHidden.toggle() }
        case .updateCategory:
            [priceField, categoryField,
             descriptionTextView, imageOneTextView,
             imageTwoTextView, imageThreeTextView
            ].forEach { $0.isHidden.toggle() }
        case .deleteCategory, .deleteProduct:
            [titleField, priceField,
             categoryField, descriptionTextView,
             imageOneTextView, imageTwoTextView,
             imageThreeTextView
            ].forEach { $0.isHidden.toggle() }
        }
    
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        [
             searchField, titleField,
            priceField, categoryField,
            descriptionTextView, imageOneTextView,
             imageTwoTextView, imageThreeTextView
        ].forEach(stackView.addArrangedSubview(_:))
    }

    private func setConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }
    
    func setData(_ data: [Category]) {
        categoryField.viewModel.separateCategories(data)
    }
    
    func getCategoryId() -> Int? {
        guard let name = categoryField.currentText else { return nil }
        let id = categoryField.viewModel.getCategoryId(name)
        return id
    }
}
