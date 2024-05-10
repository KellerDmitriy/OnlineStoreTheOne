//
//  UpdateProductViewController.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 27.04.2024.
//

import UIKit
import Combine

final class UpdateProductViewController: UIViewController {
    
    //MARK: - Private Properties
    private var viewModel: UpdateProductViewModel!
    
    private var subscriptions: Set<AnyCancellable> = []
    private let productView = ContainerManagersView(type: .updateProduct)
    private let scrollView = UIScrollView()
    private let mainStackView = UIStackView()
    
    private lazy var saveButton = FilledButtonFactory(
        title: "Save",
        type: .greenButton,
        action: UIAction(handler: { [weak self] _ in
            guard let self else { return }
            Task {
                await self.updateProduct()
            }
            navigationController?.popViewController(animated: true)
        })
    ).createButton()
    
    private lazy var cancelButton = FilledButtonFactory(
        title: "Cancel",
        type: .grayButton,
        action: UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
    ).createButton()
    
    private lazy var buttonsStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 30
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UpdateProductViewModel(networkService: NetworkService.init())
        
        setupViews()
        setConstraints()
        setActions()
    }
    
    //MARK: - Private Methods
    private func setActions() {
        productView.actionPublisher.sink { [weak self] action in
            guard let self else { return }
            switch action {
            case .titleField(let title):
                viewModel.title = title
            case .priceField(let price):
                viewModel.price = Int(price)
            case .categoryField(_):
                break
            case .descriptionView(_):
                break
            case .imageOneView(_):
                break
            case .imageTwoView(_):
                break
            case .imageThreeView(_):
                break
            case .searchView(let text):
                Task {
                    await self.findProductByTitle(text)
                }
            }
        }.store(in: &subscriptions)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "Update product"
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(productView)
        productView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.hidesBackButton = true
        view.addSubview(buttonsStackView)
        [saveButton, cancelButton].forEach { button in
            button.titleLabel?.font = UIFont.makeTypography(.medium, size: 16)
            buttonsStackView.addArrangedSubview(button)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(buttonsStackView.snp.top).offset(-20)
        }
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        productView.snp.makeConstraints {
            $0.top.equalTo(mainStackView.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.trailing.equalToSuperview()
        }
        
        hideKeyboardWhenTappedAround()
    }
    
    private func setConstraints() {
        buttonsStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        [saveButton, cancelButton].forEach { $0.snp.makeConstraints { $0.height.equalTo(50) } }
    }
    
    private func findProductByTitle(_ title: String) async {
        let result = await viewModel.networkService.fetchAllProducts()
        switch result {
        case .success(let products):
            let filteredProducts = products.filter { $0.title.lowercased().contains(title.lowercased()) }
            if let firstProduct = filteredProducts.first {
                print("Найден продукт: \(firstProduct.title) с ID: \(firstProduct.id)")
                productView.setTextOnTitleField(firstProduct.title)
                productView.setTextOnPriceField("\(firstProduct.price)")
                viewModel.id = firstProduct.id
            } else {
                print("Продукт с названием '\(title)' не найден.")
            }
        case .failure(let error):
            print("Ошибка при запросе продуктов: \(error)")
        }
    }
    
    private func updateProduct() async {
        guard let id = viewModel.id, let updateProduct = viewModel.productUpdate else { return }
        
        let result = await viewModel.networkService.updateProduct(id: id, updateData: updateProduct)
        switch result {
        case .success():
            print("Product successfully updated.")
        case .failure(let error):
            print("Error updating product: \(error)")
        }
    }
}
