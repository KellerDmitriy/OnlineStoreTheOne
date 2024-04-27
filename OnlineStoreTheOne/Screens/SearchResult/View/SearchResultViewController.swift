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
    let searchField = SearchFieldCollectionViewCell()
    
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
        
        setupCollectionView()
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
        setSearchBar()
        let cartButton = CartButton()
        cartButton.addTarget(self, action: #selector(addToCartTap), for: .touchUpInside)
        let cartBarButtonItem = UIBarButtonItem(customView: cartButton)
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        navigationItem.rightBarButtonItem = cartBarButtonItem
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setSearchBar() {
        let frame = CGRect(x: 40, y: 0, width: 450, height: 44)
        let titleView = UIView(frame: frame)
        searchField.frame = frame
        titleView.addSubview(searchField)
        navigationItem.titleView = titleView
        searchField.searchTextField.delegate = self
    }
    
    //MARK: - Actions
    func cartButtonTapped(_ product: Products) {
         viewModel.addToCarts(product: product)
     }
    
    @objc func addToCartTap() {
        let viewControllerToPresent = CartsViewController()
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
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

        searchField.translatesAutoresizingMaskIntoConstraints = false
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
