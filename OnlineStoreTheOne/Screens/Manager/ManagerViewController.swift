//
//  ManagerViewController.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 18.04.2024.
//

import UIKit

final class ManagerViewController: UIViewController {
    
    private let addNewProductButton = FilledButtonFactory(
        title: "Add New Product",
        type: .greenButton,
        action: UIAction(handler: { _ in
            print("Add New Product Button Tapped")
        })
    ).createButton()
    
    private let updateProductButton = FilledButtonFactory(
        title: "Update Product",
        type: .greenButton,
        action: UIAction(handler: { _ in
            print("Update  Product Button Tapped")
        })
    ).createButton()
    
    private let deleteProductButton = FilledButtonFactory(
        title: "Delete Product",
        type: .greenButton,
        action: UIAction(handler: { _ in
            print("Delete Product Button Tapped")
        })
    ).createButton()
    
    private let createCategoryButton = FilledButtonFactory(
        title: "Create Category",
        type: .greenButton,
        action: UIAction(handler: { _ in
            print("Create Category Button Tapped")
        })
    ).createButton()
    
    private let updateCategoryButton = FilledButtonFactory(
        title: "Update Category",
        type: .greenButton,
        action: UIAction(handler: { _ in
            print("Update Category Button Tapped")
        })
    ).createButton()
    
    private let deleteCategoryButton = FilledButtonFactory(
        title: "Delete Category",
        type: .greenButton,
        action: UIAction(handler: { _ in
            print("Delete Category Button Tapped")
        })
    ).createButton()
    
    private let buttonsStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = 24
        $0.axis = .vertical
        return $0
    }(UIStackView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.addSubview(buttonsStackView)
        [addNewProductButton, updateProductButton,
         deleteProductButton, createCategoryButton,
         updateCategoryButton, deleteCategoryButton
        ].forEach { button in
            button.titleLabel?.font = UIFont.makeTypography(.medium, size: 16)
            buttonsStackView.addArrangedSubview(button)
        }
        
        navigationController?.navigationBar.addBottomBorder()
        title = "Manager Screen"
    }
    
    private func setupConstraints() {
        buttonsStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(24)
            $0.leading.trailing.equalToSuperview().inset(42)
            $0.centerX.equalToSuperview()
        }
        
        [addNewProductButton, updateProductButton,
         deleteProductButton, createCategoryButton,
         updateCategoryButton, deleteCategoryButton
        ].forEach { $0.snp.makeConstraints { $0.height.equalTo(50) } }
    }
}
