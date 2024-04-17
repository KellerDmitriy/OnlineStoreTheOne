//
//  HomeViewController.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//

import UIKit
import SnapKit
import SwiftUI

final class HomeViewController: UIViewController {
    //MARK: - Properties
    var viewModel = MainViewModel()
    
    private let sections = MockData.shared.pageData
        
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
        view.backgroundColor = .white
        addViews()
        setupViews()
        setDelegates()
    }
    
    //MARK: - Private methods
    private func setupViews() {
        collectionView.register(TextFieldCollectionViewCell.self, forCellWithReuseIdentifier: "TextFieldCollectionViewCell")
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        collectionView.register(HeaderNavBarMenuView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderNavBarMenuView")
        collectionView.register(HeaderProductsView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProductsView")
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    

}
//MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
            
        case .textField(_):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextFieldCollectionViewCell", for: indexPath) as?
                    TextFieldCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case .categories(let categories):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(image: categories[indexPath.row].image, category: categories[indexPath.row].categories)
            return cell

        case .products(let products):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as?
                    ProductCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(image: products[indexPath.row].image, title: products[indexPath.row].title, price: products[indexPath.row].price)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let section = sections[indexPath.section]
            switch section {
            case .textField(_):
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                 withReuseIdentifier: "HeaderNavBarMenuView",
                                                                                 for: indexPath) as! HeaderNavBarMenuView
                header.configureHeader(labelName: section.title)
                return header
            case .categories(_):
                fallthrough
            case .products(_):
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "HeaderProductsView",
                                                                             for: indexPath) as! HeaderProductsView
                header.configureHeader(labelName: section.title)
                return header
            }
        default:
            return UICollectionReusableView()
        }
    }


    
}

//MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
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
            case .textField(_):
                return self.createTextFieldSection()
            case .categories(_):
                return self.createCategorySection()
            case .products(_):
                return self.createProductSection()
            }
        }
    }
    
    private func createLayoutSection(group: NSCollectionLayoutGroup,
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
    
    private func createTextFieldSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                         heightDimension: .absolute(20)),
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.supplementariesFollowContentInsets = false
        section.interGroupSpacing = 16
        section.boundarySupplementaryItems = [supplementaryHeaderItem()]
        section.contentInsets = .init(top: 30, leading: 20, bottom: 40, trailing: 20)
        return section
        
    }
    private func createCategorySection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(57),
                                                                         heightDimension: .absolute(61)),
                                                       subitems: [item])
        let section = createLayoutSection(group: group,
                                          behavior: .continuous,
                                          interGroupSpacing: 16,
                                          supplementaryItems: [],
                                          contentInsets: false)
        section.contentInsets = .init(top: 0, leading: 16, bottom: 32, trailing: 16)
        return section
    }
    
    private func createProductSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(349),
                                                                         heightDimension: .absolute(217)),
                                                       subitems: [item])
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
