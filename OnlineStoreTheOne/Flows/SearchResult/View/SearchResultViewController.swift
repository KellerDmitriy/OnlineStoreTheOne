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
    let viewModel: SearchResultViewModel

    //MARK: Private properties
    private var searchBarIsEmpty: Bool {
        guard let text = customNavigationBar.searchBarView.searchBar.searchTextField.text else { return false }
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
    
    //MARK: - Actions
    func cartButtonTapped(_ productID: Int) {
        viewModel.addToCart(productID)
    }
    
    override func cartBarButtonTap() {
        viewModel.showCartsFlow()
    }
   
    override func backBarButtonTap() {
        viewModel.dismissScreen()
    }
}

// MARK: - UISearchResultsUpdating, TextFieldDelegate
extension SearchResultViewController: SearchBarViewDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text ?? ""
        viewModel.searchedProducts = viewModel.products.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
#warning("разобраться с методом")
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
        collectionView.register(ProductCollectionViewCell.self)
        collectionView.registerHeader(HeaderProductsView.self)
    }
    
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        customNavigationBar.searchBarView.delegate = self
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.topOffset)
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
            heightDimension: .estimated(Constants.headerEstimatedHeight)
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
                    widthDimension: .absolute(Constants.itemWidth),
                    heightDimension: .absolute(Constants.itemHeight)),
                    subitems: [item]
        )
        group.interItemSpacing = .fixed(Constants.itemSpacing)
        let section = NSCollectionLayoutSection(group: group)
        section.supplementariesFollowContentInsets = false
        section.interGroupSpacing = Constants.itemSpacing
        section.boundarySupplementaryItems = [headerSupplementary]
        section.contentInsets = Constants.contentInset
        return section
    }
    
}
// MARK: - UICollectionViewDelegateFlowLayout
extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: Constants.headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderProductsView", for: indexPath) as! HeaderProductsView
        headerView.configureHeader(labelName: "\(Resources.Texts.searchResultHeader) \(viewModel.searchText)")
        return headerView
    }
}

extension SearchResultViewController {
    enum Constants {
        static let topOffset: CGFloat = 70.0
        static let itemWidth: CGFloat = 349.0
        static let itemHeight: CGFloat = 217.0
        static let itemSpacing: CGFloat = 16.0
        static let contentInset: NSDirectionalEdgeInsets = .init(top: 16, leading: 20, bottom: 16, trailing: 20)
        static let headerEstimatedHeight: CGFloat = 30.0
        static let headerHeight: CGFloat = 50.0
    }
}
