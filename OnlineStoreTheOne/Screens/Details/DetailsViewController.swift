//
//  DetailsViewController.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 21.04.2024.
//

import UIKit
import Combine

final class DetailsViewController: UIViewController {
    //MARK: - Private Properties
    private let viewModel: DetailsProductViewModel
    
    private let scrollView = UIScrollView()
    private let mainStackView = UIStackView()
    private let photoCollection = PhotoCollectionView()
    private let productList = ProductListView()
    
    private lazy var addToCartButton = FilledButtonFactory(
        title: "Add to Cart",
        type: .greenButton,
        action: UIAction(handler: { [weak self] _ in
            self?.cartButtonTap()
            
        })
    ).createButton()
    
    private lazy var buyNowButton = FilledButtonFactory(
        title: "Buy Now",
        type: .grayButton,
        action: UIAction(handler: { [weak self] _ in
            self?.payButtonTap()
        })
    ).createButton()
    
    private lazy var buttonStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 16
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private let separatorLine: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = Colors.gray.withAlphaComponent(0.2)
        return $0
    }(UIView())
    
    //MARK: - Lifecycle
    init(viewModel: DetailsProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setupNavigation()
        bind()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    //MARK: - Private Methods
    private func bind() {
        viewModel.$product
            .receive(on: DispatchQueue.main)
            .sink { [weak self] product in
                self?.productList.setProduct(name: product.title)
                self?.productList.setProduct(price: "$ \(product.price)")
                self?.productList.setProductDescription(text: product.description ?? "nil")
                self?.photoCollection.set(data: product.images ?? [""])
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        [scrollView, mainStackView, buttonStackView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(photoCollection)
        mainStackView.addArrangedSubview(productList)
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        
        view.addSubview(buttonStackView)
        [addToCartButton, buyNowButton].forEach(buttonStackView.addArrangedSubview(_:))
        view.addSubview(separatorLine)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(separatorLine.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.leading.equalTo(view.snp.leading).offset(20)
            $0.trailing.equalTo(view.snp.trailing).offset(-20)
        }
        
        addToCartButton.snp.makeConstraints {
            $0.height.equalTo(46)
        }
        
        buyNowButton.snp.makeConstraints {
            $0.height.equalTo(46)
        }
        
        separatorLine.snp.makeConstraints {
            $0.bottom.equalTo(buttonStackView.snp.top).offset(-14)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

// MARK: - Setup Navigation & Actions
private extension DetailsViewController {
    //    MARK: - Actions
    func payButtonTap() {
        let vc = PaymentSuccessView()
        if let presentationController = vc.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
            self.present(vc, animated: true)
        }
    }
    
    func cartButtonTap() {
        viewModel.storageService
            .addItem(CartsModel.self, viewModel.product) { result in
            switch result {
            case .success:
                print("Item added from cart successfully")
            case .failure(let error):
                print("Error adding/removing item from wishlist: \(error)")
            }
        }
    }
    
    func setupNavigation() {
        navigationController?.setupNavigationBar()
        navigationController?.navigationBar.addBottomBorder()
        navigationItem.title = "Details product"
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem = backButton
        
        let cartButton = CartButton()
        cartButton.addTarget(self, action: #selector(addToCartTap), for: .touchUpInside)
        let cartButtonItem = UIBarButtonItem(customView: cartButton)
        navigationItem.rightBarButtonItem = cartButtonItem
        
    }
    
    @objc private func backButtonTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func addToCartTap() {
        let viewControllerToPresent = CartsViewController()
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}
