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
        
        let cart: CartsModel = viewModel.cartProducts[indexPath.row]
        cell.configureCell(
            cart,
            onTrashTapped: { [weak self] in
                guard let self = self else { return }
                
                self.trashButtonTap(id: cart.id)
                tableView.reloadData()
                
            }, 
            countDidChange: { [weak self] count in
                self?.updateCount(cart.id, newCount: count)
            }
        )
        return cell
    }
    
    //    MARK: - Action
    
    func checkMarkButtonTap(id: Int) {
        viewModel.checkSelected(for: id)
    }
    
    
    func trashButtonTap(id: Int) {
        viewModel.removeFromCart(id)
    }
    
    func updateCount(_ productID: Int, newCount: Int) {
        viewModel.productCount = newCount
        viewModel.updateItemCount(for: productID, newCount: newCount)
    }
}

