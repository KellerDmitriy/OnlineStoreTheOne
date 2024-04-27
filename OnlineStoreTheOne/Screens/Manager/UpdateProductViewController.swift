//
//  UpdateProductViewController.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 27.04.2024.
//

import UIKit

class UpdateProductViewController: BaseManagersViewController {

    let productView = ContainerManagersView(type: .updateProduct)
    let scrollView = UIScrollView()
    let mainStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
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
}
