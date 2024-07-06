//
//  SearchBarView + Extension.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 30.06.2024.
//

import UIKit

extension SearchBarView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        toggleSearchButton(with: !searchText.isEmpty)
        delegate?.searchBar(searchBar, textDidChange: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismiss(searchBar)
        delegate?.searchBarSearchButtonClicked(searchBar)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        toggleSearchButton(with: !(searchBar.text?.isEmpty ?? true))
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        toggleSearchButton(with: false)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cancelAction(with: searchBar)
    }
}

// MARK: - Private Methods
private extension SearchBarView {
    func withAnimation(animatable: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3) {
            animatable()
        }
    }
    
    func dismiss(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func cancelAction(with searchBar: UISearchBar) {
        withAnimation { [self] in
        searchBar.text = nil
        searchBar.showsCancelButton = false
        dismiss(searchBar)
            layoutIfNeeded()
        }
        delegate?.searchBarCancelButtonClicked(searchBar)
    }
}
