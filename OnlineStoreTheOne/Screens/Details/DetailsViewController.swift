//
//  DetailsViewController.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 21.04.2024.
//

import UIKit

class DetailsViewController: UIViewController {
    
    let url = [
        "https://irecommend.ru/sites/default/files/product-images/89783/cWCQ0wc9M8G3AksvHKWsg.jpg",
        "https://top-azia.ru/wp-content/uploads/2009/06/oteli-turtsii-otzyvy.95992843.jpg",
        "https://i2.photo.2gis.com/images/branch/0/30258560076741797_1cd9.jpg"
    ]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollection.items = url
        
        setupViews()
        setConstraints()
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
