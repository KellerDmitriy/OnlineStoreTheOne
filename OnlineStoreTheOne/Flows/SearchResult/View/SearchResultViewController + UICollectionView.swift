//
//  SearchResultViewController + UICollectionView.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 27.04.2024.
//

import UIKit

// MARK: - UICollectionViewDataSource
extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchedProducts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        let product = viewModel.searchedProducts[indexPath.item]
        cell.configureCell(image: product.images?.first ?? "",
                           title: product.title,
                           price: "$\(String(product.price))",
                           addToCartCompletion: { [weak self] in
            self?.cartButtonTapped(product.id) }
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SearchResultViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = viewModel.searchedProducts[indexPath.row]
        
        viewModel.showDetailFlow(selectedProduct.id)
    }
}

