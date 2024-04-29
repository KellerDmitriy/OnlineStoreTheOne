//
//  HomeViewController.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//

import UIKit
import SnapKit
import SwiftUI
import AlertKit

final class HomeViewController: UIViewController {
    //MARK: - Properties
    var viewModel: HomeViewModel!
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        
        view.backgroundColor = .white
        addViews()
        setupViews()
        setDelegates()
        
        observeProducts()
        observeError()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCategory()
        viewModel.fetchProducts(for: viewModel.selectedCategory)
    }
    
    // MARK: - Data Observing
    private func observeProducts() {
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
    }
    
    
    private func observeError() {
            viewModel.$productsError
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] error in
                    guard let self = self else { return }
                    self.showAlertError(error: error)
                }
                .store(in: &viewModel.subscription)

            viewModel.$categoriesError
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] error in
                    guard let self = self else { return }
                    self.showAlertError(error: error)
                }
                .store(in: &viewModel.subscription)
        }

    func showAlertError(error: Error) {
        AlertKitAPI.present(title: "Error", subtitle: "\(error)", icon: .error, style: .iOS16AppleMusic, haptic: .error)
    }
    
    //MARK: - Private methods
    private func setupViews() {
        collectionView.register(SearchFieldCollectionViewCell.self)
        collectionView.register(CategoryCollectionViewCell.self)
        collectionView.register(ProductCollectionViewCell.self)
        collectionView.register(HeaderNavBarMenuView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderNavBarMenuView")
        collectionView.register(HeaderProductsView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProductsView")
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
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "HeaderNavBarMenuView",
                    for: indexPath
                ) as! HeaderNavBarMenuView
                header.configureHeader(labelName: section.title)
                header.cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
                return header
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
        default:
            return UICollectionReusableView()
        }
    }
    
    //MARK: - Action
    func addToCartButtonTapped(_ product: Products) {
        viewModel.addToCarts(product: product)
    }
    
    @objc private func cartButtonTapped() {
        let viewControllerToPresent = CartsViewController()
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}

//MARK: - AddViews
extension HomeViewController {
    private func addViews() {
        view.addSubview(collectionView)
        addConstraints()
    }
    
    private func addConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
        section.boundarySupplementaryItems = [supplementaryHeaderItem()]
        section.contentInsets = .init(top: 30, leading: 20, bottom: 40, trailing: 20)
        return section
        
    }
    private func createCategorySection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .absolute(57),
            heightDimension: .absolute(61)),
            subitems: [item]
        )
        let section = createLayoutSection(
            group: group,
            behavior: .continuous,
            interGroupSpacing: 16,
            supplementaryItems: [],
            contentInsets: false
        )
        section.contentInsets = .init(top: 0, leading: 16, bottom: 32, trailing: 16)
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
    
}

//MARK: - PreviewProvider
struct ContentViewController_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewController()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentViewController: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = HomeViewController
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        return HomeViewController()
    }
    
    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {}
}
