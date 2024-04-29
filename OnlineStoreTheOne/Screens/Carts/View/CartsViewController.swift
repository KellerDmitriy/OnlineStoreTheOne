//
//  CartsViewController.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//

import UIKit
import SnapKit

final class CartsViewController: UIViewController {
    var viewModel: CartsViewModel!
    
    //    MARK: - UI elements
    private lazy var locationTitleLabel: UILabel = {
        NewLabelFactory(text: "Delivery to:", font: .extraLight, color: .black, size: 16).createLabel()
    }()
    
    private lazy var locationLabel: UILabel = {
        NewLabelFactory(text: "Moroco, St. 1/4", font: .extraLight, color: .black, size: 16).createLabel()
    }()
    
    private lazy var summaryLabel: UILabel = {
        NewLabelFactory(text: "Order Summary:", font: .extraBold, color: .black, size: 16).createLabel()
    }()
    
    private lazy var totalLabel: UILabel = {
        NewLabelFactory(text: "Totals:", font: .medium, color: .black, size: 16).createLabel()
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        NewLabelFactory(text: "100 $", font: .extraBold, color: .black, size: 16).createLabel()
    }()
    
    let cartButton = CartButton()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private let separatorLine: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = Colors.gray.withAlphaComponent(0.2)
        return $0
    }(UIView())
    
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
        viewModel = CartsViewModel()
       
        setupViews()
        setupLayout()
        configureTableView()
        
        setupNavigationBar()
        observeCartProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProductsFromCart()
    }
    
    // MARK: - Data Observing
       private func observeCartProducts() {
           viewModel.$cartProducts
               .receive(on: DispatchQueue.main)
               .sink { [weak self] carts in
                   self?.tableView.reloadData()
                   self?.cartButton.count = carts?.count ?? 0
               }
               .store(in: &viewModel.subscription)
       }
    
    private func observe() {
        viewModel.$isSelect
            .sink { [weak self] isSelect in
                //                self?.updateIsSelectedInCart(isSelected: isSelect)
            }
            .store(in: &viewModel.subscription)
        
        viewModel.$productCount
            .sink { [weak self] count in
                //                self?.updateProductCountInCart(count: count)
            }
            .store(in: &viewModel.subscription)
    }
    
    
    //    MARK: - Setup
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(locationTitleLabel)
        view.addSubview(locationLabel)
        
        view.addSubview(tableView)
        
        view.addSubview(separatorLine)
        view.addSubview(totalLabel)
        view.addSubview(summaryLabel)
        view.addSubview(totalPriceLabel)
        
        view.addSubview(payButton)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartsTableViewCell.self, forCellReuseIdentifier: CartsTableViewCell.cellID)
        tableView.rowHeight = Constants.rowHeight
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Your Cart"
        navigationController?.navigationBar.addBottomBorder()
        
        navigationController?.navigationBar.tintColor = .black
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem = backButton
        
        
        let cartButtonItem = UIBarButtonItem(customView: cartButton)
        navigationItem.rightBarButtonItem = cartButtonItem
        
    }
    
    @objc private func backButtonTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func setupLayout() {
        locationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                   .offset(Constants.verticalSpacing)
            make.leading.equalTo(Constants.horizontalSpacing)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                   .offset(Constants.verticalSpacing)

            make.trailing.equalToSuperview().inset(Constants.horizontalSpacing)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(locationTitleLabel.snp.bottom)
                .offset(Constants.verticalSpacing)
            make.leading.trailing.equalToSuperview()
                .inset(Constants.horizontalSpacing)
            make.bottom.equalTo(separatorLine.snp.top)
                .offset(-Constants.verticalSpacing)
        }
        
        separatorLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                .inset(Constants.separatorSpacing)
        }
        
        summaryLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(Constants.verticalSpacing)
            make.leading.equalTo(Constants.horizontalSpacing)

        }
        
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(Constants.verticalSpacing)
            make.leading.equalTo(Constants.horizontalSpacing)
        }

        totalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(Constants.verticalSpacing)
            make.trailing.equalToSuperview().inset(Constants.horizontalSpacing)
        }
        
        payButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(Constants.verticalSpacing)
            make.leading.trailing.equalToSuperview()
                .inset(Constants.horizontalSpacing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                .inset(Constants.bottomSpacing)
            make.height.equalTo(Constants.heightForButton)
        }
    }
    
    //    MARK: - Action
    private func payButtonTap() {
        let vc = PaymentSuccessView()
        if let presentationController = vc.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
            self.present(vc, animated: true)
        }
    }
}

// MARK: - Constants
extension CartsViewController {
    struct Constants {
        static let rowHeight: CGFloat = 120
        static let horizontalSpacing: CGFloat = 16
        static let verticalSpacing: CGFloat = 20
        static let heightForButton: CGFloat = 50
        static let bottomSpacing: CGFloat = 20
        static let separatorSpacing: CGFloat = 180
    }
}
