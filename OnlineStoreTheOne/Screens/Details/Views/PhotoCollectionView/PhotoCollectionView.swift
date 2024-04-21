//
//  PhotoCollectionView.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 21.04.2024.
//

import UIKit

final class PhotoCollectionView: UIView {
    
    private lazy var pageIndicator: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.layer.cornerRadius = 5
        pc.backgroundStyle = .prominent
        pc.addTarget(self, action: #selector(didChangePage(control:)), for: .valueChanged)
        return pc
    }()
    
    private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = .init(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.width * 0.733
        )
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(PhotoCell.self)
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .clear
        return collection
    }()
    
    var items: [String] = [] {
        didSet {
            pageIndicator.numberOfPages = items.count
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(collectionView)
        addSubview(pageIndicator)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pageIndicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            pageIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.733)
        ])
    }
    
    @objc
    private func didChangePage(control: UIPageControl) {
        collectionView.scrollToItem(
            at: .init(row: control.currentPage, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
    }
}

extension PhotoCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageIndicator.currentPage = indexPath.row
    }
}

extension PhotoCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCell = collectionView.dequeueCell(indexPath)
        cell.configure(with: items[indexPath.row])
        return cell
    }
}
