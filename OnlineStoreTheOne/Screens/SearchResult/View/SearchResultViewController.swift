//
//  SearchResultViewController.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 18.04.2024.
//

import UIKit
import SnapKit
import SwiftUI

final class SearchResultViewController: UIViewController {
    // MARK: - Properties
    let viewModel = SearchResultViewModel()
    
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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        collectionView.register(HeaderProductsView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProductsView")
        return collectionView
    }()
    
    lazy var searchTextField: UITextField = {
        let element = UITextField()
        element.placeholder = NSLocalizedString("Search here ...", comment: "")
        element.backgroundColor = .clear
        element.textAlignment = .left
        element.font = UIFont.makeTypography(.regular, size: 13)
        element.autocapitalizationType = .words
        element.returnKeyType = .search
        return element
    }()
    
    // MARK: - Init
    init(searchText: String) {
        super.init(nibName: nil, bundle: nil)
        if !searchText.isEmpty {
            viewModel.fetchSearchProducts(searchText)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setupNavigationBar()
        observeProducts()
        
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
        navigationController?.setupNavigationBar()
        navigationController?.navigationBar.addBottomBorder()
        
        let searchField = SearchFieldCollectionViewCell()
        navigationItem.titleView = searchField
        
        let cartButton = CartButton()
        cartButton.addTarget(self, action: #selector(addToCartTap), for: .touchUpInside)
        let cartBarButtonItem = UIBarButtonItem(customView: cartButton)
        
        navigationItem.rightBarButtonItem = cartBarButtonItem
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func addToCartTap() {
        let viewControllerToPresent = CartsViewController()
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    private func cartButtonTapped(_ product: Products) {
        viewModel.addToCarts(product: product)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - UICollectionViewDataSource
extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchedProducts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        let product = viewModel.searchedProducts[indexPath.item]
        cell.configureCell(image: product.image ?? "",
                           title: product.title,
                           price: String(product.price),
                           addToCartCompletion: { [weak self] in
            self?.cartButtonTapped(product) }
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SearchResultViewController: UICollectionViewDelegate {
    
}

//MARK: - AddViews
extension SearchResultViewController {
    private func addViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        addConstraints()
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
        headerView.configureHeader(labelName: "Search result for ")
        return headerView
    }
}

//MARK: - PreviewProvider
struct SearchContentViewController_Previews: PreviewProvider {
    static var previews: some View {
        SearchContentViewController()
            .edgesIgnoringSafeArea(.all)
    }
}
struct SearchContentViewController: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = SearchResultViewController
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        return SearchResultViewController(searchText: "")
    }
    
    func updateUIViewController(_ uiViewController: SearchResultViewController, context: Context) {}
}
