//
//  HomeViewController.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    //MARK: - Properties
    let viewModel: HomeViewModel
    let coordinator: IHomeCoordinator
    
    let sections = SectionsData.shared.sections
    
    var isSelectedCategory: Bool {
        return viewModel.selectedCategory == nil
    }
    
    let customNavigationBar = CustomNavigationBarImpl()
    
    lazy var collectionView: UICollectionView = {
        let collectViewLayout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectViewLayout)
        collectionView.backgroundColor = .none
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: - Init
    init(viewModel: HomeViewModel, coordinator: IHomeCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setupViews()
        setDelegates()
       
        customNavigationBar.setupConfiguration(configureNavigationBar())
        actionForCartButton()
        
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
        coordinator.finish()
    }
    

    
    // MARK: - Data Observing
    private func observeProducts() {
        NotificationCenter.default.addObserver(self, selector: #selector(allCategoriesButtonTap), name: NSNotification.Name("allCategoriesButtonTapped"), object: nil)
        
        viewModel.$products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadData()
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
        
        viewModel.$productCount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
//                let header = HeaderNavBarMenuView()
//                header.cartButton.count = viewModel.productCount
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
            .sink { [weak self] error in
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
            
            coordinator.showAlertController(title: "Error", message: message) {
                retryAction()
            }
        }
    }
    
    //MARK: - Methods for Navigation
    func configureNavigationBar() -> CustomNavigationBarConfiguration? {
       CustomNavigationBarConfiguration(
        title: "",
        withSearchTextField: false,
        isSetupBackButton: false,
        isSetupCartButton: true
        )
    }
    
    func actionForCartButton() {
        customNavigationBar.cartButton.addAction(UIAction { [weak self] _ in
            self?.cartButtonTapped()
        },
    for: .touchUpInside)
    }
    
    //MARK: - Action
    @objc func allCategoriesButtonTap() {
        viewModel.toggleCategoryExpansion()
    }
    
    func addToCartButtonTapped(_ product: Products) {
        viewModel.addToCart(product.id)
    }
    
    @objc private func cartButtonTapped() {
        coordinator.showCartsFlow()
    }
    
    //MARK: - Private methods
    private func setupViews() {
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
            case .searchField:
                fallthrough
            case .categories:
                fallthrough
            case .products:
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "HeaderProductsView",
                    for: indexPath
                ) as! HeaderProductsView
                header.configureHeader(labelName: section.title)
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
    private func addViews() {
        view.backgroundColor = .white
        view.addSubview(customNavigationBar)
        view.addSubview(collectionView)
        
        addConstraints()
    }
    
    private func addConstraints() {
        customNavigationBar.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom).offset(8)
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
                heightDimension: .absolute(20)),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.supplementariesFollowContentInsets = false
        section.interGroupSpacing = 16
        section.boundarySupplementaryItems = []
        section.contentInsets = .init(top: 16, leading: 16, bottom: 33, trailing: 16)
        return section
        
    }
    
    private func createCategorySection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
        )
      
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .absolute(70),
            heightDimension: .absolute(70)),
            subitems: [item]
        )
        let section = createLayoutSection(
            group: group,
            behavior: .groupPaging,
            interGroupSpacing: 16,
            supplementaryItems: [supplementaryFooterItem()],
            contentInsets: false
        )
        section.contentInsets = .init(top: 0, leading: 16, bottom: 33, trailing: 16)
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
                widthDimension: .absolute(349),
                heightDimension: .absolute(217)),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(16)
        let section = NSCollectionLayoutSection(group: group)
        section.supplementariesFollowContentInsets = false
        section.interGroupSpacing = 16
        section.boundarySupplementaryItems = [supplementaryHeaderItem()]
        section.contentInsets = .init(top: 16, leading: 20, bottom: 16, trailing: 20)
        return section
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .estimated(30)),
              elementKind: UICollectionView.elementKindSectionHeader,
              alignment: .top)
    }
    
    private func supplementaryFooterItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        return .init(layoutSize: .init(widthDimension: .fractionalWidth(0.9),
                                       heightDimension: .absolute(48.3)),
                     elementKind: UICollectionView.elementKindSectionFooter,
                     alignment: .bottom)
    }
    
}


