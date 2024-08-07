//
//  WishListViewController.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 16.04.2024.
//

import UIKit

final class WishListViewController: BaseViewController {
    let viewModel: WishListViewModel
    
    //MARK: Private properties
    private var searchBarIsEmpty: Bool {
        guard let text = customNavigationBar.searchBarView.searchBar.searchTextField.text else { return false }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        return !searchBarIsEmpty
    }
    
    //    MARK: - UI elements
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Init
    init(viewModel: WishListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
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
        navigationController?.navigationBar.isHidden = true
        navigationController?.tabBarItem.title = Resources.Text.wishList
        
        customNavigationBar.searchBarView.delegate = self
        
    }
    
    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
        CustomNavigationBarConfiguration(
            withSearchTextField: true,
            isSetupBackButton: false,
            isSetupCartButton: true
        )
    }
    
    // MARK: - Actions
    override func cartBarButtonTap() {
        viewModel.showCartsFlow()
    }
    
    override func backBarButtonTap() {
        viewModel.coordinatorFinish()
    }
    
    // MARK: - UI Setup
    func animateCollectionView() {
        UIView.transition(with: collectionView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
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
        collectionView.register(WishListCollectionCell.self)
    }
    
    override func addViews() {
        super.addViews()
        setupCollectionView()
        view.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.topAnchor)
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
}

// MARK: - UISearchResultsUpdating, TextFieldDelegate
extension WishListViewController: SearchBarViewDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text ?? ""
        viewModel.filteredWishList = viewModel.wishList.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        #warning("разобраться с методом")
    }

}

//MARK: Constants
extension WishListViewController {
    enum Constants {
        static let topAnchor: CGFloat = 60
        static let horizontalSpacing: CGFloat = 20
        static let interItemSpacing: CGFloat = 20
    }
}
