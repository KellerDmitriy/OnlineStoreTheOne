//
//  HomeViewController + UICollection.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 26.04.2024.
//

import UIKit

//MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
            
        case .searchField(_):
            let cell: SearchFieldCollectionViewCell = collectionView.dequeueCell(indexPath)
            
            cell.searchTextField.delegate = self
            return cell
            
        case .categories(_):
            let cell: CategoryCollectionViewCell = collectionView.dequeueCell(indexPath)
            
            if indexPath.row < viewModel.categories.count {
                let category = viewModel.categories[indexPath.row]
                cell.configureCell(image: category.image ?? "",
                                   category: category.name ?? "")
            }
            return cell
            
        case .products(_):
            let cell: ProductCollectionViewCell = collectionView.dequeueCell(indexPath)
            
            if indexPath.row < viewModel.products.count {
                let product = viewModel.products[indexPath.row]
                cell.configureCell(
                    image: product.images?.first ?? "",
                    title: product.title,
                    price: "$\(String(product.price))",
                    addToCartCompletion: {  [weak self] in
                        self?.addToCartButtonTapped(product)
                    }
                )
            }
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
            
        case .searchField(_):
#warning("добавить логику")
        case .categories(_):
            let category = viewModel.categories[indexPath.row]
            viewModel.fetchProducts(for: category.id)
            
            collectionView.reloadData()
    
        case .products(_):
            let selectedProduct = viewModel.products[indexPath.row]
            let detailViewModel = DetailsProductViewModel(productId: selectedProduct.id)
            
            let detailViewController = DetailsViewController(viewModel: detailViewModel)
            let navigationController = UINavigationController(rootViewController: detailViewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}

//MARK: - UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    
    //TODO: -
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let searchText = textField.text {
            viewModel.fetchSearchProducts(searchText)
            
            let searchResultsVC = SearchResultViewController()
            searchResultsVC.searchResults = viewModel.products
            self.navigationController?.pushViewController(searchResultsVC, animated: true)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
