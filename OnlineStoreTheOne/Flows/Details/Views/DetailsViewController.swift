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
    
    private let scrollView = UIScrollView()
    private let mainStackView = UIStackView()
    private let photoCollection = PhotoCollectionView()
    private let productList = ProductListView()
    
    private lazy var addToCartButton = FilledButtonFactory(
        title: Resources.Text.addToCart,
        type: .greenButton,
        action: UIAction(handler: { [weak self] _ in
            self?.cartButtonTap()
        })
    ).createButton()
    
    private lazy var buyNowButton = FilledButtonFactory(
        title: Resources.Text.buyNow,
        type: .grayButton,
        action: UIAction(handler: { [weak self] _ in
            self?.payButtonTap()
        })
    ).createButton()
    
    private lazy var buttonStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = Constants.buttonStackSpacing
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
        actionForAddToWishListButtonTap()
        bind()
        changeToWishListButton()
    }
    
    deinit {
        viewModel.coordinator?.finish()
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
    
    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
        CustomNavigationBarConfiguration(
            title: Resources.Text.detailsProductTitle,
            isSetupBackButton: true,
            isSetupCartButton: true
        )
    }
    
    override func addViews() {
        super.addViews()
        
        [
            scrollView,
            mainStackView,
            buttonStackView
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(photoCollection)
        mainStackView.addArrangedSubview(productList)
        mainStackView.axis = .vertical
        mainStackView.spacing = Constants.mainStackViewSpacing
        
        view.addSubview(buttonStackView)
        [addToCartButton, buyNowButton].forEach(buttonStackView.addArrangedSubview(_:))
        view.addSubview(separatorLine)
    }
    
    override func cartBarButtonTap() {
        viewModel.showCartFLow()
    }
    
    override func backBarButtonTap() {
        viewModel.dismissScreen()
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.scrollViewTopOffset)
            $0.bottom.equalTo(separatorLine.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(Constants.buttonStackBottomOffset)
            $0.leading.equalTo(view.snp.leading).offset(Constants.buttonStackLeadingOffset)
            $0.trailing.equalTo(view.snp.trailing).offset(Constants.buttonStackTrailingOffset)
        }
        
        addToCartButton.snp.makeConstraints {
            $0.height.equalTo(Constants.buttonHeight)
        }
        
        buyNowButton.snp.makeConstraints {
            $0.height.equalTo(Constants.buttonHeight)
        }
        
        separatorLine.snp.makeConstraints {
            $0.bottom.equalTo(buttonStackView.snp.top).offset(Constants.separatorLineBottomOffset)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.separatorLineHeight)
        }
    }
}

// MARK: - Actions
private extension DetailsViewController {
    func payButtonTap() {
        viewModel.showPayScene()
    }
    
    func cartButtonTap() {
        viewModel.addToCart()
    }
    
    func actionForAddToWishListButtonTap() {
        productList.addToWishListButton.addAction(UIAction { [weak self] _ in
            self?.addToWishListButtonTap()
        },
        for: .touchUpInside
        )
    }
    
    func addToWishListButtonTap () {
        viewModel.favoriteButtonPressed()
    }
    
    func setToAddToWishListButton(_ status: Bool) {
        let image = status ? Resources.Image.selectedWishlist : Resources.Image.wishList
        productList.addToWishListButton.setImage(image, for: .normal)
    }
}

//MARK: Constants
extension DetailsViewController {
    enum Constants {
        static let scrollViewTopOffset: CGFloat = 70
        static let buttonStackBottomOffset: CGFloat = -10
        static let buttonStackLeadingOffset: CGFloat = 20
        static let buttonStackTrailingOffset: CGFloat = -20
        static let buttonHeight: CGFloat = 46
        static let separatorLineBottomOffset: CGFloat = -14
        static let separatorLineHeight: CGFloat = 1
        static let mainStackViewSpacing: CGFloat = 16
        static let buttonStackSpacing: CGFloat = 16
    }
}
