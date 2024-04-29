//
//  DeleteProductViewController.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 27.04.2024.
//

import UIKit
import Combine

final class DeleteProductViewController: UIViewController {
    
    let viewModel = DeleteProductViewModel()
    private var subscriptions: Set<AnyCancellable> = []

    private let productView = ContainerManagersView(type: .deleteProduct)
    private let scrollView = UIScrollView()
    private let mainStackView = UIStackView()
    
    private lazy var saveButton = FilledButtonFactory(
        title: "Delete",
        type: .greenButton,
        action: UIAction(handler: { [weak self] _ in
            guard let self else { return }
            Task {
                await self.deleteProduct()
            }
            navigationController?.popViewController(animated: true)
            print("Delete Button Tapped")
        })
    ).createButton()
    
    private lazy var cancelButton = FilledButtonFactory(
        title: "Cancel",
        type: .grayButton,
        action: UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
            print("Cancel Button Tapped")
        })
    ).createButton()
    
    private lazy var buttonsStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 30
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private lazy var foundProductTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Product found:"
        $0.font = .makeTypography(.bold, size: 18)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var idProductTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "ID:"
        $0.font = .makeTypography(.bold, size: 16)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var idProductLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "_"
        $0.font = .makeTypography(.bold, size: 16)
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    private lazy var idLabelsStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView())
    
    private lazy var nameProductTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Name:"
        $0.font = .makeTypography(.bold, size: 16)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var nameProductLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "_"
        $0.font = .makeTypography(.bold, size: 16)
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    private lazy var nameLabelsStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView())
    
    private lazy var priceProductTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Price:"
        $0.font = .makeTypography(.bold, size: 16)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var priceProductLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "_"
        $0.font = .makeTypography(.bold, size: 16)
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    private lazy var priceLabelsStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView())
    
    private lazy var mainLabelsStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = 20
        $0.axis = .vertical
        return $0
    }(UIStackView())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setConstraints()
        bind()
        
        productView.actionPublisher.sink { [weak self] action in
            guard let self else { return }
            switch action {
            case .titleField(_):
                break
            case .priceField(_):
                break
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
        title = "Delete product"
        
        hideKeyboardWhenTappedAround()
        
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
        
        [idProductTitle, idProductLabel].forEach(idLabelsStackView.addArrangedSubview(_:))
        [nameProductTitle, nameProductLabel].forEach(nameLabelsStackView.addArrangedSubview(_:))
        [priceProductTitle, priceProductLabel].forEach(priceLabelsStackView.addArrangedSubview(_:))
        
        mainStackView.addArrangedSubview(foundProductTitle)
        mainStackView.addArrangedSubview(mainLabelsStackView)
        
        [
            idLabelsStackView,
            nameLabelsStackView,
            priceLabelsStackView
        ].forEach(mainLabelsStackView.addArrangedSubview(_:))
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 30
    }
    
    private func setConstraints() {
        buttonsStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        [saveButton, cancelButton].forEach { $0.snp.makeConstraints { $0.height.equalTo(50) } }
        
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
        
        foundProductTitle.snp.makeConstraints {
            $0.top.equalTo(productView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
        }
        
        mainLabelsStackView.snp.makeConstraints {
            $0.top.equalTo(foundProductTitle.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func findProductByTitle(_ title: String) async {
         let result = await NetworkService.shared.fetchAllProducts()
         switch result {
         case .success(let products):
             let filteredProducts = products.filter { $0.title.lowercased().contains(title.lowercased()) }
             if let firstProduct = filteredProducts.first {
                 viewModel.id = "\(firstProduct.id)"
                 viewModel.title = firstProduct.title
                 viewModel.price = "\(firstProduct.price)"
                 print("Найден продукт: \(firstProduct.title) с ID: \(firstProduct.id)")
             } else {
                 print("Продукт с названием '\(title)' не найден.")
                 viewModel.id = "-"
                 viewModel.price = "_"
                 viewModel.title = "-"
             }
         case .failure(let error):
             print("Ошибка при запросе продуктов: \(error)")
         }
     }
    
    private func deleteProduct() async {
        guard let id = Int(viewModel.id ?? "") else { return }
        let result = await NetworkService.shared.deleteProductById(id)
        switch result {
        case .success():
            print("Product successfully deleted.")
        case .failure(let error):
            print("Failed to delete product: \(error)")
        }
    }
    
    private func bind() {
        viewModel.$id.receive(on: DispatchQueue.main).sink { [weak self] id in
            self?.idProductLabel.text = id
        }.store(in: &subscriptions)
        
        viewModel.$title.receive(on: DispatchQueue.main).sink { [weak self] name in
            self?.nameProductLabel.text = name
        }.store(in: &subscriptions)
        
        viewModel.$price.receive(on: DispatchQueue.main).sink { [weak self] price in
            self?.priceProductLabel.text = price
        }.store(in: &subscriptions)
    }
}
