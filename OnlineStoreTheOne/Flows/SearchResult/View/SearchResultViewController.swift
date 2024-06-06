//
//  SearchResultViewController.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 18.04.2024.
//

import UIKit
import SnapKit

final class SearchResultViewController: BaseViewController {
    // MARK: - Properties
    var viewModel: SearchResultViewModel
    let coordinator: ISearchResultCoordinator
    
    //MARK: Private properties
    private var searchBarIsEmpty: Bool {
        guard let text = customNavigationBar.searchTextFieldCell.searchTextField.text else { return false }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        return !searchBarIsEmpty
    }
    
    // MARK: - UI Components
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
    init(viewModel: SearchResultViewModel, coordinator: ISearchResultCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()

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
    
    
    //MARK: - Override methods
    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
        CustomNavigationBarConfiguration(
        withSearchTextField: true,
        isSetupBackButton: true,
        isSetupCartButton: true
        )
    }
    //MARK: - Private methods
    
    
    //MARK: - Actions
    func cartButtonTapped(_ productID: Int) {
        viewModel.addToCart(productID)
    }
    
    override func cartBarButtonTap() {
        coordinator.showCartsFlow()
    }
   
    override func backBarButtonTap() {
#warning("переделать")
        navigationController?.popToRootViewController(animated: true)
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
    override func addViews() {
        super.addViews()
        
        view.addSubview(collectionView)
    }
    
    private func setupCollectionView() {
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
    
    override func setupConstraints() {
        super.setupConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
                    subitems: [item]
        )
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
        return CGSize(width: collectionView.bounds.width, height: 50)
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
