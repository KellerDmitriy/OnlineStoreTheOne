//
//  CartsViewController.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//

import UIKit
import SnapKit

final class CartsViewController: BaseViewController {
    let viewModel: CartsViewModel

    // MARK: - UI elements
    private lazy var locationTitleLabel: UILabel = {
        LabelFactory(
            text: Resources.Texts.deliveryTo,
            font: .extraLight,
            color: .black,
            size: 16
        )
        .createLabel()
    }()
    
    private lazy var locationLabel: UILabel = {
        LabelFactory(
            text: Resources.Texts.moroccoAddress,
            font: .extraLight,
            color: .black,
            size: 16
        )
        .createLabel()
    }()
    
    private lazy var summaryLabel: UILabel = {
        LabelFactory(
            text: Resources.Texts.orderSummary,
            font: .extraBold,
            color: .black,
            size: 16
        )
        .createLabel()
    }()
    
    private lazy var totalLabel: UILabel = {
        LabelFactory(
            text: Resources.Texts.totals,
            font: .medium,
            color: .black,
            size: 16
        )
        .createLabel()
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        LabelFactory(
            text: Resources.Texts.hundredDollars,
            font: .extraBold,
            color: .black,
            size: 16
        )
        .createLabel()
    }()
    
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
            title: Resources.Texts.selectedPaymentMethod,
            type: .greenButton,
            action: UIAction { [weak self] _ in
                self?.payButtonTap()
            }
        )
        return filledButtonFactory.createButton()
    }()
    
    // MARK: - Init
    init(viewModel: CartsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(Resources.Texts.error)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeCartProducts()
        observeTotal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProductsFromCart()
        viewModel.getOrderSummery()
    }
    
    // MARK: - Data Observing
    private func observeCartProducts() {
        viewModel.$cartProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] carts in
                self?.animateCollectionView()
            }
            .store(in: &viewModel.subscription)
    }
    
    private func observeTotal() {
        viewModel.$orderSummary
            .receive(on: DispatchQueue.main)
            .sink { [weak self] total in
                self?.totalPriceLabel.text = "\(total) $"
            }
            .store(in: &viewModel.subscription)
    }
    
    // MARK: - Override Methods
    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
        CustomNavigationBarConfiguration(
        title: Resources.Texts.yourCart,
        isSetupBackButton: true,
        isSetupCartButton: true
        )
    }
    
    override func cartBarButtonTap() {
        viewModel.showCartsScene()
    }
    
    override func backBarButtonTap() {
        viewModel.dismissCartsScene()
    }
    
    func animateCollectionView() {
        UIView.transition(with: tableView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        }, completion: nil)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartsTableViewCell.self, forCellReuseIdentifier: CartsTableViewCell.cellID)
        tableView.rowHeight = Constants.rowHeight
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubview(locationTitleLabel)
        view.addSubview(locationLabel)
        
        view.addSubview(tableView)
        
        view.addSubview(separatorLine)
        view.addSubview(totalLabel)
        view.addSubview(summaryLabel)
        view.addSubview(totalPriceLabel)
        
        view.addSubview(payButton)
        
        configureTableView()
    }
    override func setupConstraints() {
        super.setupConstraints()
        
        locationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.tppSpacing)
            make.leading.equalTo(Constants.horizontalSpacing)
        }

        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.tppSpacing)
            make.trailing.equalToSuperview().inset(Constants.horizontalSpacing)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(Constants.verticalSpacing)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalSpacing)
            make.bottom.equalTo(separatorLine.snp.top).offset(-Constants.verticalSpacing)
        }

        separatorLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(summaryLabel.snp.top).offset(-Constants.verticalSpacing)
        }

        summaryLabel.snp.makeConstraints { make in
            make.leading.equalTo(Constants.horizontalSpacing)
            make.bottom.equalTo(totalLabel.snp.top).offset(-Constants.verticalSpacing)
        }

        totalLabel.snp.makeConstraints { make in
            make.leading.equalTo(Constants.horizontalSpacing)
            make.bottom.equalTo(totalPriceLabel.snp.top).offset(-Constants.verticalSpacing)
        }

        totalPriceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.horizontalSpacing)
            make.bottom.equalTo(payButton.snp.top).offset(-Constants.verticalSpacing)
        }

        payButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalSpacing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                           .inset(Constants.bottomSpacing)
            make.height.equalTo(Constants.heightForButton)
        }
    }
    
    //    MARK: - Action
    private func payButtonTap() {
        viewModel.showPayFlow()
    }
}

// MARK: - Constants
extension CartsViewController {
    enum Constants {
        static let tppSpacing: CGFloat = 40
        static let rowHeight: CGFloat = 150
        static let horizontalSpacing: CGFloat = 16
        static let verticalSpacing: CGFloat = 20
        static let heightForButton: CGFloat = 50
        static let bottomSpacing: CGFloat = 20
        static let separatorSpacing: CGFloat = 180
    }
}
