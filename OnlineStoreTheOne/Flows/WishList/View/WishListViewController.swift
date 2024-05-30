//
//  WishListViewController.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 16.04.2024.
//

import UIKit

final class WishListViewController: BaseViewController {
    let viewModel: WishListViewModel
    let coordinator: IWishListCoordinator
    
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
    
    private let searchBarContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    init(viewModel: WishListViewModel, coordinator: IWishListCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        
        setupUI()
        super.viewDidLoad()
        
        configureNavBar()
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
    
    //MARK: - NavigationController
    func configureNavBar() {
        title = "Your WishList"
        navigationController?.tabBarItem.title = "Wish List"
        addNavBarButton(at: .cartButton)
    }
    
    // MARK: - Actions
    override func cartBarButtonTap() {
        coordinator.showCartsFlow()
    }
    
    // MARK: - UI Setup
    func animateCollectionView() {
        UIView.transition(with: collectionView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
    }
    
    private func setupUI() {
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
        
    }
    
    private func configureCollectionView(with layout: UICollectionViewLayout) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func registerCollectionViewCells() {
        collectionView.register(WishListCollectionCell.self, forCellWithReuseIdentifier: WishListCollectionCell.cellID)
    }
    
    override func addViews() {
        super.addViews()
        view.addSubview(collectionView)
        view.addSubview(searchBarContainer)
        searchBarContainer.addSubview(searchController.searchBar)
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        searchBarContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalSpacing)
            make.height.equalTo(50)
        }
        
        searchController.searchBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBarContainer.snp.bottom).offset(Constants.topAnchor)
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
    
    // MARK: - Navigation & SearchController

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
