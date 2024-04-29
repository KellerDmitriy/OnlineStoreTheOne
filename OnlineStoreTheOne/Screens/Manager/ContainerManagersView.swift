//
//  ContainerManagersView.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 27.04.2024.
//

import UIKit
import Combine

enum ContainerType {
    case addNewProduct, addNewCategory
    case updateProduct, updateCategory
    case deleteProduct, deleteCategory
}

final class ContainerManagersView: UIView {
    
    //MARK: - Actions type
    enum Action {
        case titleField(String)
        case priceField(String)
        case categoryField(String)
        case descriptionView(String)
        case imageOneView(String)
        case imageTwoView(String)
        case imageThreeView(String)
        case searchView(String)
    }
    
    //MARK: - Private Properties
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
    
    //MARK: - Public Properties
    let actionPublisher = PassthroughSubject<Action, Never>()
    
    //MARK: - Lifecycle
    init(type: ContainerType) {
        self.type = type
        super.init(frame: .zero)
        setupViews()
        setConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
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
    
    private func setupActions() {
        titleField.textChanged = { [weak self] text in
            guard let self, let text else { return }
            actionPublisher.send(.titleField(text))
        }
        
        priceField.textChanged = { [weak self] text in
            guard let self, let text else { return }
            actionPublisher.send(.priceField(text))
        }
        
        categoryField.textChanged = { [weak self] text in
            guard let self, let text else { return }
            actionPublisher.send(.categoryField(text))
        }
        
        descriptionTextView.textChanged = { [weak self] text in
            guard let self, let text else { return }
            actionPublisher.send(.descriptionView(text))
        }
        
        imageOneTextView.textChanged = { [weak self] text in
            guard let self, let text else { return }
            actionPublisher.send(.imageOneView(text))
        }
        
        imageTwoTextView.textChanged = { [weak self] text in
            guard let self, let text else { return }
            actionPublisher.send(.imageTwoView(text))
        }
        
        imageThreeTextView.textChanged = { [weak self] text in
            guard let self, let text else { return }
            actionPublisher.send(.imageThreeView(text))
        }
        
        searchField.textChanged = { [weak self] text in
            guard let self, let text else { return }
            actionPublisher.send(.searchView(text))
        }
    }
    
    //MARK: - Public Methods
    func setData(_ data: [Category]) {
        categoryField.viewModel.separateCategories(data)
    }
    
    func getCategoryId(_ name: String) -> Int? {
        let id = categoryField.viewModel.getCategoryId(name)
        return id
    }
    
    func setTextOnTitleField(_ text: String) {
        titleField.setText(text)
    }
    
    func setTextOnPriceField(_ text: String) {
        priceField.setText(text)
    }
}
