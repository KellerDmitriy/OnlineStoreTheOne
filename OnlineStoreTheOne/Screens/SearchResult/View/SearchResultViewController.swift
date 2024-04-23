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
    
    var searchResults = [Products(id: 1, title: "Product 1", price: 10, description: "Description 1", category: nil, image: "tv"),
                         Products(id: 2, title: "Product 2", price: 20, description: "Description 2", category: nil, image: "airpoods"),
                         Products(id: 3, title: "Product 3", price: 30, description: "Description 3", category: nil, image: "ps4"),
                         Products(id: 3, title: "Product 3", price: 30, description: "Description 3", category: nil, image: "mug"),
                         Products(id: 3, title: "Product 3", price: 30, description: "Description 3", category: nil, image: "ps4"),
                         Products(id: 3, title: "Product 3", price: 30, description: "Description 3", category: nil, image: "mug"),
    ]
    
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
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        setupNavigationBar()
        collectionView.reloadData()
        
    }
    //MARK: - Private methods
    private func setupNavigationBar() {
        
//        let searchField = SearchFieldCollectionViewCell()
//        navigationItem.titleView = searchField
        
        let cartButton = UIButton()
        cartButton.setImage(UIImage(systemName: "cart"), for: .normal)
        cartButton.tintColor = .black
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        let cartBarButtonItem = UIBarButtonItem(customView: cartButton)
        
        navigationItem.rightBarButtonItem = cartBarButtonItem
    }
    @objc private func cartButtonTapped() {
        print("нажата - Cart")
    }
}
// MARK: - UICollectionViewDataSource
extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        let product = searchResults[indexPath.item]
        cell.configureCell(image: product.image ?? "", 
                           title: product.title,
                           price: "$\(String(product.price))")
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SearchResultViewController: UICollectionViewDelegate {
    
}
//MARK: - AddViews
extension SearchResultViewController {
    private func addViews() {
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
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(30))
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                              elementKind: UICollectionView.elementKindSectionHeader,
                                                                              alignment: .top)
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(349),
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
        return SearchResultViewController()
    }

    func updateUIViewController(_ uiViewController: SearchResultViewController, context: Context) {}
}

