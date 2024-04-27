//
//  CartsViewController + UITableView.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 15.04.2024.
//

import UIKit

extension CartsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartsTableViewCell.cellID,
            for: indexPath
        ) as? CartsTableViewCell else { return UITableViewCell() }
        
        let cart = viewModel.cartProducts[indexPath.row]
        cell.configureCell(cart)
        
        cell.counterActionButton.plusButton.addAction(UIAction { [weak self] _ in
            self?.plusButtonTap(id: cart.id)
        }, for: .touchUpInside)
        
        cell.counterActionButton.minusButton.addAction(UIAction { [weak self] _ in
            self?.plusButtonTap(id: cart.id)
        }, for: .touchUpInside)
        
        cell.counterActionButton.trashButton.addAction(UIAction { [weak self] _ in
            self?.plusButtonTap(id: cart.id)
        }, for: .touchUpInside)
        
        return cell
    }
    
//    MARK: - Action
    func plusButtonTap(id: Int) {
       viewModel.incrementCountProduct(for: id)
    }
    
    func minusButtonTap(id: Int) {
        viewModel.decrementCountProduct(for: id)
    }
    
    func trashButtonTap(id: Int) {
        viewModel.removeFromCart(id)
    }
}
