//
//  CartsViewController.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//

import UIKit
import SnapKit

final class CartsViewController: UIViewController {
    var viewModel = CartsViewModel()
    
    //    MARK: - UI elements
    private lazy var label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartsTableViewCell.self, forCellReuseIdentifier: CartsTableViewCell.cellID)
        return tableView
    }()
    
    private lazy var payButton: UIButton = {
        let filledButtonFactory = FilledButtonFactory(
            title: "Selected payment method",
            type: .greenButton,
            action: UIAction { [weak self] _ in
                self?.payButtonTap()
            }
        )
        return filledButtonFactory.createButton()
    }()
    
    //    MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupLayout()
        setupNavigationBar()
        observeCartProducts()
    }
    
    // MARK: - Data Observing
       private func observeCartProducts() {
           viewModel.$cartProducts
               .receive(on: DispatchQueue.main)
               .sink { [weak self] _ in
                   self?.tableView.reloadData()
               }
               .store(in: &viewModel.subscription)
       }
    
    //    MARK: - Setup
    private func setupViews() {
        navigationItem.title = "Your Cart"
        view.addSubview(tableView)
        view.addSubview(payButton)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem = backButton
        
        let cartButton = CartButton()
        let cartButtonItem = UIBarButtonItem(customView: cartButton)
        navigationItem.rightBarButtonItem = cartButtonItem
        
    }
    
    @objc private func backButtonTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .offset(Constants.verticalSpacing)
            make.leading.trailing.equalToSuperview()
                .inset(Constants.horizontalSpacing)
            make.bottom.equalTo(payButton.snp.top)
                .inset(Constants.bottomSpacing)
        }
        
        payButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
                .inset(Constants.horizontalSpacing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                .inset(Constants.bottomSpacing)
            make.height.equalTo(Constants.heightForButton)
        }
    }
    
    //    MARK: - Methods
    private func payButtonTap() {
        
    }
}

// MARK: - Constants
extension CartsViewController {
    struct Constants {
        static let horizontalSpacing: CGFloat = 16
        static let verticalSpacing: CGFloat = 100
        static let heightForButton: CGFloat = 50
        static let bottomSpacing: CGFloat = 20
    }
}
