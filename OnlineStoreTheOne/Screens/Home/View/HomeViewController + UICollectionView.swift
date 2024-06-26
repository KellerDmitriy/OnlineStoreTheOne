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
        guard section >= 0 && section <= sections.count else {
            return 0
        }

        let currentSection = sections[section]
        switch currentSection {
            case .searchField:
                return 1
            case .categories:
                return viewModel.categories.count
            case .products:
                return viewModel.products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
            
        case .searchField:
            let cell: SearchFieldCollectionViewCell = collectionView.dequeueCell(indexPath)
            
            cell.searchTextField.delegate = self
            return cell
            
        case .categories:
            let cell: CategoryCollectionViewCell = collectionView.dequeueCell(indexPath)
            
            if indexPath.row < viewModel.categories.count {
                let category = viewModel.categories[indexPath.row]
                cell.configureCell(image: category.image ?? "",
                                   category: category.name ?? "")
            }
            return cell
            
        case .products:
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
        case .searchField: break
        case .categories:
            let category = viewModel.categories[indexPath.row]
            viewModel.updateCategory(category.id)
            
            SectionsData.shared.selectedCategoryTitle = category.name ?? ""
            
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                collectionView.deselectItem(at: selectedIndexPath, animated: true)
            }
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        case .products:
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
            let searchResultsVC = SearchResultViewController(searchText: searchText)
            
            let navigationController = UINavigationController(rootViewController: searchResultsVC)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
        textField.text = ""
        return true
    }
}


