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
            return viewModel.isCategoryExpanded
            ? viewModel.categories.count
            : min(4, viewModel.categories.count)
            
            case .products:
            return viewModel.productsForCategory.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
            
        case .searchField:
            let cell = collectionView.dequeueReusableCell(type: SearchFieldCollectionViewCell.self, for: indexPath)
            
            cell.searchTextField.delegate = self
            return cell
            
        case .categories:
            let cell = collectionView.dequeueReusableCell(type: CategoryCollectionViewCell.self, for: indexPath)
            cell.makeCellShadow()
            if indexPath.row < viewModel.categories.count {
                let category = viewModel.categories[indexPath.row]
                cell.configureCell(image: category.image ?? "",
                                   category: category.name ?? "")
            }
            return cell
            
        case .products:
            let cell = collectionView.dequeueReusableCell(type: ProductCollectionViewCell.self, for: indexPath)
            cell.makeCellShadow()
            if indexPath.row < viewModel.products.count {
                
                let product = viewModel.productsForCategory[indexPath.row]
                
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
            let selectedProduct = viewModel.productsForCategory[indexPath.row]
            viewModel.coordinator?.showDetailFlow(productId: selectedProduct.id)
        }
    }
}


//MARK: - UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.inputView = UIView()
        viewModel.showSearchResultFlow()
    }
}


