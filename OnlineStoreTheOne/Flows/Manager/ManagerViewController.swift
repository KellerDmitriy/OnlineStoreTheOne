//
//  ManagerViewController.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 18.04.2024.
//

import UIKit

final class ManagerViewController: UIViewController {
     //MARK: - Private Properties
    private lazy var addNewProductButton = FilledButtonFactory(
        title: "Add New Product",
        type: .greenButton,
        action: UIAction(handler: { [weak self] _ in
            let vc = AddNewProductViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
            print("Add New Product Button Tapped")
        })
    ).createButton()
    
    private lazy var updateProductButton = FilledButtonFactory(
        title: "Update Product",
        type: .greenButton,
        action: UIAction(handler: { [weak self] _ in
            let vc = UpdateProductViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
            print("Update  Product Button Tapped")
        })
    ).createButton()
    
    private lazy var deleteProductButton = FilledButtonFactory(
        title: "Delete Product",
        type: .greenButton,
        action: UIAction(handler: { [weak self] _ in
            let vc = DeleteProductViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
            print("Delete Product Button Tapped")
        })
    ).createButton()
    
    private lazy var createCategoryButton = FilledButtonFactory(
        title: "Create Category",
        type: .greenButton,
        action: UIAction(handler: { [weak self] _ in
            let vc = AddNewCategoryViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
            print("Create Category Button Tapped")
        })
    ).createButton()
    
    private lazy var updateCategoryButton = FilledButtonFactory(
        title: "Update Category",
        type: .greenButton,
        action: UIAction(handler: { [weak self] _ in
            let vc = UpdateCategoryViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
            print("Update Category Button Tapped")
        })
    ).createButton()
    
    private lazy var deleteCategoryButton = FilledButtonFactory(
        title: "Delete Category",
        type: .greenButton,
        action: UIAction(handler: { [weak self] _ in
            let vc = DeleteCategoryViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
            print("Delete Category Button Tapped")
        })
    ).createButton()
    
    private let buttonsStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = 24
        $0.axis = .vertical
        return $0
    }(UIStackView())
    
     //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }

     //MARK: - Private Methods
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
