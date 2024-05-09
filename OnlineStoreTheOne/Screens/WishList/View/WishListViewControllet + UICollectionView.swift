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
        return  isFiltering ? viewModel.filteredWishList.count : viewModel.wishList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishListCollectionCell.cellID, for: indexPath) as? WishListCollectionCell else {
            return UICollectionViewCell()
        }
        
        let product = isFiltering
        ? viewModel.filteredWishList[indexPath.item] 
        : viewModel.wishList[indexPath.item]
        
        cell.configureCell(product)
        cell.makeCellShadow()
        cell.addToCartCompletion = { [weak self] in
            self?.viewModel.addToCart(product.id)
        }
        
        cell.removeFromWishListCompletion = { [weak self] in
            self?.viewModel.removeWishList(at: product.id)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension WishListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedWishList = isFiltering
        ? viewModel.filteredWishList[indexPath.item]
        : viewModel.wishList[indexPath.item]
        
        let detailViewModel = DetailsProductViewModel(productId: selectedWishList.id, networkService: NetworkService(), storageService: StorageService())
        let detailViewController = DetailsViewController(viewModel: detailViewModel)
        let navigationController = UINavigationController(rootViewController: detailViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}


