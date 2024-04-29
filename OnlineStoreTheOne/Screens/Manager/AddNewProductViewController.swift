//
//  AddNewProductViewController.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 27.04.2024.
//

import UIKit
import Combine

final class AddNewProductViewController: UIViewController {
    
    let viewModel = AddNewProductViewModel()
    private var subscriptions: Set<AnyCancellable> = []

    private let productView = ContainerManagersView(type: .addNewProduct)
    private let scrollView = UIScrollView()
    private let mainStackView = UIStackView()
    
    private lazy var saveButton = FilledButtonFactory(
        title: "Save",
        type: .greenButton,
        action: UIAction(handler: { [weak self] _ in
            guard let self else { return }
            Task {
                await self.addNewProduct()
            }
            navigationController?.popViewController(animated: true)
            print("Save Button Tapped")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
        setupViews()
        setConstraints()
        
        productView.actionPublisher.sink { [weak self] action in
            guard let self else { return }
            switch action {
            case .titleField(let title):
                viewModel.title = title
            case .priceField(let price):
                viewModel.price = Int(price)
            case .categoryField(let category):
                viewModel.category = productView.getCategoryId(category)
            case .descriptionView(let description):
                viewModel.description = description
            case .imageOneView(let url):
                viewModel.imageOne = url
            case .imageTwoView(let url):
                viewModel.imageTwo = url
            case .imageThreeView(let url):
                viewModel.imageThree = url
            case .searchView(_):
                break
            }
        }.store(in: &subscriptions)
    }

    private func setupViews() {
        view.backgroundColor = .white
        title = "Add new product"
        
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
    
    private func fetchCategories() {
        Task {
            let result = await NetworkService.shared.fetchCategory()
            switch result {
            case .success(let success):
                productView.setData(success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func addNewProduct() async {
        guard let newProduct = viewModel.product else { return }

        let result = await NetworkService.shared.createProduct(product: newProduct)
            switch result {
            case .success(let response):
                print("Продукт успешно добавлен с ID \(response.id) и категорией \(response.category.name).")
            case .failure(let error):
                print("Ошибка при добавлении продукта: \(error)")
            }
    }
   
}
