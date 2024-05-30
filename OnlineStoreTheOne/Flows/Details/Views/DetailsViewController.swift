//
//  DetailsViewController.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 21.04.2024.
//

import UIKit
import Combine

final class DetailsViewController: BaseViewController {
    //MARK: - Private Properties
    private let viewModel: DetailsProductViewModel
    let coordinator: IDetailCoordinator
    
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
    init(viewModel: DetailsProductViewModel, coordinator: IDetailCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setupConstraints()
        setupNavigation()
        actionForAddToWishListButtonTap()
        bind()
        changeToWishListButton()
    }
    
    deinit {
        coordinator.finish()
    }
    
    //MARK: - Private Methods
    private func bind() {
        viewModel.$product
            .receive(on: DispatchQueue.main)
            .sink { [weak self] product in
                self?.productList.setProduct(name: product.title)
                self?.productList.setProduct(price: "$ \(product.price)")
                self?.productList.setProductDescription(text: product.description)
                self?.photoCollection.set(data: product.images ?? [""])
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func changeToWishListButton() {
        viewModel.$isSaved
            .receive(on: DispatchQueue.main)
        
            .sink { [weak self] isSaved in
                self?.setToAddToWishListButton(isSaved)
            }
            .store(in: &viewModel.cancellables)
    }
    
    override func addViews() {
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
    
    private func setupNavigation() {
        addNavBarButton(at: .backButton)
        addNavBarButton(at: .cartButton)
        navigationItem.title = "Details product"
    }
    
    override func cartBarButtonTap() {
        coordinator.showCartsFlow()
    }
    
//    MARK: Override methods
    override func setupConstraints() {
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

// MARK: - Actions
private extension DetailsViewController {
    func payButtonTap() {
        coordinator.showPayScene()
    }
    
    func cartButtonTap() {
        viewModel.addToCart()
    }
    
    func actionForAddToWishListButtonTap() {
        productList.addToWishListButton.addAction(UIAction { [weak self] _ in
            self?.addToWishListButtonTap()
        },
        for: .touchUpInside)
    }
    
    func addToWishListButtonTap () {
        viewModel.favoriteButtonPressed()
    }
    
    func setToAddToWishListButton(_ status: Bool) {
        let image = status ? UIImage(named: "selectedWishlist") : UIImage(named: "Wishlist")
        productList.addToWishListButton.setImage(image, for: .normal)
    }
    

}
