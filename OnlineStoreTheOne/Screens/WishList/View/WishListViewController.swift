//
//  WishListViewController.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 16.04.2024.
//

import UIKit

final class WishListViewController: UIViewController {
    
    var viewModel = WishListViewModel()
    
    //MARK: Private properties
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    //    MARK: - UI elements
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        viewModel.$wishLists
            .sink { [weak self] _ in
                Task {
                    self?.collectionView.reloadData()
                }
            }
            .store(in: &viewModel.subscription)

        viewModel.getData(id: 100)
    }
           
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white

        setupNavigation()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = createLayout()
        configureCollectionView(with: layout)
        registerCollectionViewCells()
        addCollectionViewConstraints()
    }
    private func configureCollectionView(with layout: UICollectionViewLayout) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    
    private func registerCollectionViewCells() {
        collectionView.register(WishListCollectionCell.self, forCellWithReuseIdentifier: WishListCollectionCell.cellID)
    }
    
    private func addCollectionViewConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.topAnchor)
            make.leading.equalTo(view).offset(Constants.horizontalSpacing)
            make.trailing.equalTo(view).offset(-Constants.horizontalSpacing)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-Constants.interItemSpacing)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let availableWidth = view.frame.width -  Constants.interItemSpacing * 2
        let availableHeight = view.frame.height -  Constants.interItemSpacing * 3
        
        let itemWidthDimension = NSCollectionLayoutDimension.fractionalWidth(availableWidth / 2 / view.frame.width)
        let itemHightDimension = NSCollectionLayoutDimension.fractionalWidth(availableHeight / 3 / view.frame.height)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidthDimension, heightDimension: itemHightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemHightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.interItemSpacing = .fixed(Constants.interItemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.interItemSpacing
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    // MARK: - Navigation
    private func setupNavigation() {
        configureSearchController()
//        navigationController?.setupNavigationBar()
        navigationItem.searchController = searchController
    }
}

// MARK: - UISearchResultsUpdating, TextFieldDelegate
extension WishListViewController: UISearchResultsUpdating, UITextFieldDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        viewModel.filteredWishLists = viewModel.wishLists.filter { product in
            product.title.lowercased().contains(searchText.lowercased())
        }
        collectionView.reloadData()
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchController.isActive = false
        return true
    }

    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.delegate = self

        searchController.searchBar.placeholder = "Search title..."
    }
}

//MARK: Constants
extension WishListViewController {
    struct Constants {
        static let topAnchor: CGFloat = 8
        static let horizontalSpacing: CGFloat = 20
        static let interItemSpacing: CGFloat = 20
    }
}
