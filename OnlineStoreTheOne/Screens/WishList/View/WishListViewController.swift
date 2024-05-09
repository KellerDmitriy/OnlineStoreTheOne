//
//  WishListViewController.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 16.04.2024.
//

import UIKit


final class WishListViewController: UIViewController {
    var viewModel: WishListViewModel!
    
    //MARK: Private properties
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
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
        setupDependencies()
        
        setupUI()
        observeViewModelChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getWishListIDs()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func setupDependencies() {
        let networkService: NetworkServiceProtocol = NetworkService()
        let storageService: StorageServiceProtocol = StorageService()
        
        viewModel = WishListViewModel(
            networkService: networkService,
            storageService: storageService
        )
    }
    
    // MARK: - ViewModel Observing
    private func observeViewModelChanges() {
        viewModel.$wishList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.animateCollectionView()
            }
            .store(in: &viewModel.subscription)
        
        viewModel.$filteredWishList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.animateCollectionView()
            }
            .store(in: &viewModel.subscription)
    }
    
    // MARK: - Actions
    @objc func addToCartTap() {
        let viewControllerToPresent = CartsViewController()
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - UI Setup
    
    func animateCollectionView() {
        UIView.transition(with: collectionView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupNavigation()
        setupCollectionView()
        setupSearchController()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Products"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
        
        let availableWidth = view.frame.width -  Constants.interItemSpacing
        let availableHeight = view.frame.height -  Constants.interItemSpacing
        
        let itemWidthDimension = NSCollectionLayoutDimension.fractionalWidth(availableWidth / 2 / view.frame.width)
        let itemHightDimension = NSCollectionLayoutDimension.fractionalWidth(availableHeight / 1.5 / view.frame.height)
        
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
        
        navigationController?.setupNavigationBar()
        navigationItem.searchController = searchController
        
        navigationItem.title = "Your WishList"
        let cartButton = CartButton()
        cartButton.addTarget(self, action: #selector(addToCartTap), for: .touchUpInside)
        let cartButtonItem = UIBarButtonItem(customView: cartButton)
        
        navigationItem.rightBarButtonItem = cartButtonItem
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.delegate = self
        
        searchController.searchBar.placeholder = "Search title..."
    }
}

// MARK: - UISearchResultsUpdating, TextFieldDelegate
extension WishListViewController: UISearchResultsUpdating, UITextFieldDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        viewModel.filteredWishList = viewModel.wishList.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        collectionView.reloadData()
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
