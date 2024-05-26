//
//  SearchResultViewController.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 18.04.2024.
//

import UIKit
import SnapKit

final class SearchResultViewController: UIViewController {
    // MARK: - Properties
    var viewModel: SearchResultViewModel
    
    // MARK: - UI Components
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: Private properties
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    let cartButton = CartButton()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) in
            return self.createProductSection()
        }
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    // MARK: - Init
    init(viewModel: SearchResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavigationBar()
        configureSearchController()
        observeProducts()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Data Observing
    private func observeProducts() {
        viewModel.$searchedProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }
            .store(in: &viewModel.subscription)
    }
    
    //MARK: - Private methods
    private func setupNavigationBar() {
    
        navigationItem.title = "Your searched results"
        navigationItem.searchController = searchController
        
        cartButton.addTarget(self, action: #selector(addToCartTap), for: .touchUpInside)
        let cartBarButtonItem = UIBarButtonItem(customView: cartButton)

        navigationItem.rightBarButtonItem = cartBarButtonItem
    }
    
    private func configureSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.delegate = self
        
        searchController.searchBar.placeholder = "Search title..."
    }
    
    //MARK: - Actions
    func cartButtonTapped(_ productID: Int) {
        viewModel.addToCart(productID)
    }
    
    @objc func addToCartTap() {
//        let viewControllerToPresent = CartsViewController()
//        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
//        navigationController.modalPresentationStyle = .fullScreen
//        self.present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - UISearchResultsUpdating, TextFieldDelegate
extension SearchResultViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        //        let searchText = searchController.searchBar.text ?? ""
        //        viewModel.filteredWishList = viewModel.wishList.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        //        collectionView.reloadData()
    }
}

//MARK: - AddViews
extension SearchResultViewController {
    
    private func setupCollectionView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        addConstraints()
        registerCells()
        setDelegate()
    }
    
    private func registerCells() {
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        collectionView.register(HeaderProductsView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProductsView")
    }
    
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func addConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - Create Layout
extension SearchResultViewController {
    private func createProductSection() -> NSCollectionLayoutSection {
        ///хедер
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(30)
        )
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        let item = NSCollectionLayoutItem(layoutSize:
                .init(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:
                .init(
                    widthDimension: .absolute(349),
                    heightDimension: .absolute(217)),
                                                       subitems: [item])
        group.interItemSpacing = .fixed(16)
        let section = NSCollectionLayoutSection(group: group)
        section.supplementariesFollowContentInsets = false
        section.interGroupSpacing = 16
        section.boundarySupplementaryItems = [headerSupplementary]
        section.contentInsets = .init(top: 16, leading: 20, bottom: 16, trailing: 20)
        return section
    }
    
}
// MARK: - UICollectionViewDelegateFlowLayout
extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50) /// высота хедера
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderProductsView", for: indexPath) as! HeaderProductsView
        headerView.configureHeader(labelName: "Search result for \(viewModel.searchText)")
        return headerView
    }
}
