//
//  WishListViewController + UICollectionView.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 19.04.2024.
//

import UIKit

// MARK: - UICollectionViewDataSource
extension WishListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishListCollectionCell.cellID, for: indexPath) as? WishListCollectionCell else {
            return UICollectionViewCell()
        }
        
        let wishList = viewModel.products.value[indexPath.item]
        cell.configureCell(wishList)
        
        cell.addToCartCompletion = { [weak self] in
            self?.viewModel.addToCart(wishList)
        }
        
        cell.removeFromWishListCompletion = { [weak self] in
            self?.viewModel.removeWishList(at: wishList.id) {
                self?.animateCollectionView()
            }
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension WishListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedWishList = viewModel.products.value[indexPath.item]
        let detailViewModel = DetailsProductViewModel(productId: selectedWishList.id)
        let detailViewController = DetailsViewController(viewModel: detailViewModel)
        let navigationController = UINavigationController(rootViewController: detailViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}

