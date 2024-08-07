//
//  SearchBarView.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 30.06.2024.
//

import UIKit

protocol SearchBarViewDelegate: AnyObject {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
}


final class SearchBarView: UIView {
    weak var delegate: SearchBarViewDelegate?
    
    // MARK: - UI Properties
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        let image = Resources.Image.searchIcon?.withTintColor(.clear, renderingMode: .alwaysOriginal)
        search.setImage(image, for: .search, state: .normal)
        search.delegate = self
        search.barTintColor = nil
        search.tintColor = .gray
        search.searchTextPositionAdjustment = UIOffset(horizontal: 5, vertical: 1)
        search.searchTextField.placeholder = "Search"
        search.searchTextField.textColor = .gray
        search.backgroundColor = .clear
        search.searchTextField.backgroundColor = .white
        search.searchTextField.layer.borderColor = Colors.gray.cgColor
        search.searchTextField.layer.borderWidth = 0.5
        search.searchTextField.layer.cornerRadius = 8

        // Set the background image of the searchBar to a transparent image
        search.backgroundImage = UIImage()
        
        return search
    }()
    
    private lazy var searchButton: UIButton = {
        let image = Resources.Image.searchIcon
        let action = UIAction(image: image, handler: searchAction)
        let button = UIButton(type: .system, primaryAction: action)
        button.isEnabled = false
        return button
    }()
    
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Private Methods
    private func setView() {
        addSubview(searchBar)
        searchBar.addSubview(searchButton)
    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Constraints for searchBar to fill its superview
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            searchBar.searchTextField.heightAnchor.constraint(equalToConstant: 35),
            
            // Constraints for searchButton
            searchButton.topAnchor.constraint(equalTo: searchBar.searchTextField.topAnchor, constant: 5),
            searchButton.leadingAnchor.constraint(equalTo: searchBar.searchTextField.leadingAnchor, constant: 5)
            
        ])
    }
    
    // MARK: - Private Methods
    private func searchAction(_ action: UIAction) {
        searchBarSearchButtonClicked(searchBar)
    }
    
    // MARK: - Internal Methods
    func toggleSearchButton(with value: Bool) {
        searchButton.isEnabled = value
    }
}
