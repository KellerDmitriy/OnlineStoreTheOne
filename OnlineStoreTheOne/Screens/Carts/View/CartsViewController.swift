//
//  CartsViewController.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//

import UIKit
import SnapKit

final class CartsViewController: UIViewController {
    //    MARK: - Outlets
    private lazy var label: UILabel = {
    let label = UILabel()
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
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
    }
    
    //    MARK: - Setup
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(payButton)
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
