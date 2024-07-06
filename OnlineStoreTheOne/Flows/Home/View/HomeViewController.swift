//
//  HomeViewController.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//

import UIKit
import SnapKit

final class HomeViewController: BaseViewController {
    //MARK: - Properties
    let viewModel: HomeViewModel
    let sections = SectionsData.shared.sections
    
    lazy var collectionView: UICollectionView = {
        let collectViewLayout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectViewLayout)
        collectionView.backgroundColor = .none
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: - Init
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationCells()
        setDelegates()
        observeProducts()
        observeError()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCategories()
        viewModel.fetchProducts()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Data Observing
    private func observeProducts() {
        NotificationCenter.default.addObserver(self, selector: #selector(allCategoriesButtonTap), name: NSNotification.Name("allCategoriesButtonTapped"), object: nil)
        
        viewModel.$productsForCategory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadSections(IndexSet(integer: 2))
            }
            .store(in: &viewModel.subscription)
        
        viewModel.$categories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }
            .store(in: &viewModel.subscription)
        
        viewModel.$selectedCategory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }
            .store(in: &viewModel.subscription)
        
        viewModel.$isCategoryExpanded
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadSections(IndexSet(integer: 1))
            }
            .store(in: &viewModel.subscription)
    }
    
    private func observeError() {
        viewModel.$dataError
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                self.showAlertError(error: error)
            }
            .store(in: &viewModel.subscription)
        
        viewModel.$isLoading
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }
            .store(in: &viewModel.subscription)
    }
    
    func showAlertError(error: Error) {
        func showAlertError(error: DataError) {
            let message: String
            let retryAction: () -> Void
            
            switch error {
            case .productsError:
                message = error.localizedDescription
                retryAction = { [weak self] in
                    self?.viewModel.fetchProducts()
                    self?.collectionView.reloadData()
                }
            case .categoriesError:
                message = error.localizedDescription
                retryAction = { [weak self] in
                    self?.viewModel.fetchCategories()
                    self?.collectionView.reloadData()
                }
            }
            
            viewModel.coordinator?.showAlertController(title: "Error", message: message) {
                retryAction()
            }
        }
    }
    
    //MARK: - Methods for Navigation
    override func configureNavigationBar() -> CustomNavigationBarConfiguration? {
        CustomNavigationBarConfiguration(
            withLocationView: true,
            isSetupCartButton: true
        )
    }
    
    override func cartBarButtonTap() {
        viewModel.coordinator?.showCartsFlow()
    }
    
    //MARK: - Action
    @objc func allCategoriesButtonTap() {
        viewModel.toggleCategoryExpansion()
    }
    
    func addToCartButtonTapped(_ product: Products) {
        viewModel.addToCart(product.id)
    }
    
    //MARK: - Private methods
    private func registrationCells() {
        collectionView.register(SearchFieldCollectionViewCell.self)
        collectionView.register(CategoryCollectionViewCell.self)
        collectionView.registerFooter(FooterCategoriesView.self)
        collectionView.register(ProductCollectionViewCell.self)
        collectionView.registerHeader(HeaderProductsView.self)
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let section = sections[indexPath.section]
            switch section {
            case .searchField, .categories, .products:
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "HeaderProductsView",
                    for: indexPath
                ) as! HeaderProductsView
                header.configureHeader(labelName: section.title)
                header.delegate = viewModel
                return header
            }
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FooterCategoriesView.reuseIdentifier,
                for: indexPath
            ) as! FooterCategoriesView
            return footer
        default:
            return UICollectionReusableView()
        }
    }
}

//MARK: - AddViews
extension HomeViewController {
    override internal func addViews() {
        super.addViews()
//        customNavigationBar.addBottomBorder()
        view.addSubview(collectionView)
    }
    
    override internal func setupConstraints() {
        super.setupConstraints()
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.CollectionView.topOffset)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

//MARK: - Create Layout
extension HomeViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.sections[sectionIndex]
            switch section {
            case .searchField:
                return self.createSearchFieldSection()
            case .categories:
                return self.createCategorySection()
            case .products:
                return self.createProductSection()
            }
        }
    }
    
    private func createLayoutSection(
        group: NSCollectionLayoutGroup,
        behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior,
        interGroupSpacing: CGFloat,
        supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem],
        contentInsets: Bool) -> NSCollectionLayoutSection {
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = behavior
            section.interGroupSpacing = interGroupSpacing
            section.boundarySupplementaryItems = supplementaryItems
            section.supplementariesFollowContentInsets = contentInsets
            return section
        }
    
    private func createSearchFieldSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(Constants.CollectionView.SearchFieldSection.height)),
                subitems: [item]
                )
        
        let section = NSCollectionLayoutSection(group: group)
           section.supplementariesFollowContentInsets = false
           section.interGroupSpacing = Constants.CollectionView.interGroupSpacing
           section.boundarySupplementaryItems = []
           section.contentInsets = .init(
               top: Constants.CollectionView.sectionContentInset,
               leading: Constants.CollectionView.sectionContentInset,
               bottom: Constants.CollectionView.SearchFieldSection.bottomInset,
               trailing: Constants.CollectionView.sectionContentInset
           )
           return section
       }

       private func createCategorySection() -> NSCollectionLayoutSection {
           let item = NSCollectionLayoutItem(
               layoutSize: .init(
                   widthDimension: .fractionalWidth(1),
                   heightDimension: .fractionalHeight(1))
           )
           
           let group = NSCollectionLayoutGroup.horizontal(
               layoutSize: .init(
                   widthDimension: .absolute(Constants.CollectionView.CategorySection.itemWidth),
                   heightDimension: .absolute(Constants.CollectionView.CategorySection.itemHeight)),
               subitems: [item]
           )
           let section = createLayoutSection(
               group: group,
               behavior: .groupPaging,
               interGroupSpacing: Constants.CollectionView.interGroupSpacing,
               supplementaryItems: [supplementaryFooterItem()],
               contentInsets: false
           )
           section.contentInsets = .init(
               top: 0,
               leading: Constants.CollectionView.sectionContentInset,
               bottom: Constants.CollectionView.CategorySection.bottomInset,
               trailing: Constants.CollectionView.sectionContentInset
           )
           return section
       }

       private func createProductSection() -> NSCollectionLayoutSection {
           let item = NSCollectionLayoutItem(
               layoutSize: .init(
                   widthDimension: .fractionalWidth(0.5),
                   heightDimension: .fractionalHeight(1))
           )
           let group = NSCollectionLayoutGroup.horizontal(
               layoutSize: .init(
                   widthDimension: .absolute(Constants.CollectionView.ProductSection.itemWidth),
                   heightDimension: .absolute(Constants.CollectionView.ProductSection.itemHeight)),
               subitems: [item]
           )
           group.interItemSpacing = .fixed(Constants.CollectionView.interGroupSpacing)
           let section = NSCollectionLayoutSection(group: group)
           section.supplementariesFollowContentInsets = false
           section.interGroupSpacing = Constants.CollectionView.interGroupSpacing
           section.boundarySupplementaryItems = [supplementaryHeaderItem()]
           section.contentInsets = .init(
               top: Constants.CollectionView.ProductSection.topInset,
               leading: Constants.CollectionView.ProductSection.leadingInset,
               bottom: Constants.CollectionView.ProductSection.bottomInset,
               trailing: Constants.CollectionView.ProductSection.trailingInset
           )
           return section
       }

       private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
           .init(layoutSize: .init(
                   widthDimension: .fractionalWidth(1.0),
                   heightDimension: .estimated(Constants.CollectionView.Supplementary.headerHeight)),
                 elementKind: UICollectionView.elementKindSectionHeader,
                 alignment: .top)
       }

       private func supplementaryFooterItem() -> NSCollectionLayoutBoundarySupplementaryItem {
           .init(layoutSize: .init(
                   widthDimension: .fractionalWidth(Constants.CollectionView.Supplementary.footerWidth),
                   heightDimension: .absolute(Constants.CollectionView.Supplementary.footerHeight)),
                 elementKind: UICollectionView.elementKindSectionFooter,
                 alignment: .bottom)
       }
}

extension HomeViewController {
    enum Constants {
        enum CollectionView {
            static let topOffset: CGFloat = 50.0
            static let interGroupSpacing: CGFloat = 16.0
            static let sectionContentInset: CGFloat = 16.0
            
            enum SearchFieldSection {
                static let height: CGFloat = 20.0
                static let bottomInset: CGFloat = 33.0
            }
            
            enum CategorySection {
                static let itemWidth: CGFloat = 70.0
                static let itemHeight: CGFloat = 70.0
                static let bottomInset: CGFloat = 33.0
            }
            
            enum ProductSection {
                static let itemWidth: CGFloat = 349.0
                static let itemHeight: CGFloat = 217.0
                static let topInset: CGFloat = 16.0
                static let bottomInset: CGFloat = 16.0
                static let leadingInset: CGFloat = 20.0
                static let trailingInset: CGFloat = 20.0
            }
            
            enum Supplementary {
                static let headerHeight: CGFloat = 30.0
                static let footerWidth: CGFloat = 0.9
                static let footerHeight: CGFloat = 48.3
            }
        }
    }
}
