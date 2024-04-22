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
    private var cancellables: Set<AnyCancellable> = []
    
    private let scrollView = UIScrollView()
    private let mainStackView = UIStackView()
    private let photoCollection = PhotoCollectionView()
    private let productList = ProductListView()
    
    private lazy var addToCartButton = FilledButtonFactory(
        title: "Add to Cart",
        type: .greenButton,
        action: UIAction(handler: { _ in
            print("Add To Cart Button Tapped")
        })
    ).createButton()
    
    private lazy var buyNowButton = FilledButtonFactory(
        title: "Buy Now",
        type: .grayButton,
        action: UIAction(handler: { _ in
            print("Buy Now Button Tapped")
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
        bind()
    }
    
     //MARK: - Private Methods
    private func bind() {
        viewModel.$title.receive(on: DispatchQueue.main).sink { [weak self] title in
            self?.productList.setProduct(name: title)
        }.store(in: &cancellables)
        
        viewModel.$price.receive(on: DispatchQueue.main).sink { [weak self] price in
            self?.productList.setProduct(price: price)
        }.store(in: &cancellables)
        
        viewModel.$description.receive(on: DispatchQueue.main).sink { [weak self] desc in
            self?.productList.setProductDescription(text: desc ?? "nil")
        }.store(in: &cancellables)
        
        viewModel.$images.receive(on: DispatchQueue.main).sink { [weak self] images in
            guard let images else { return }
            self?.photoCollection.set(data: images)
        }.store(in: &cancellables)
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
