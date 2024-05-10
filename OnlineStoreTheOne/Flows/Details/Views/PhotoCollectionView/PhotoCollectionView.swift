//
//  PhotoCollectionView.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 21.04.2024.
//

import UIKit

final class PhotoCollectionView: UIView {
    //MARK: - Private Properties
    private lazy var pageIndicator: UIPageControl = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 8
        $0.backgroundStyle = .prominent
        $0.addTarget(self, action: #selector(didChangePage(control:)), for: .valueChanged)
        return $0
    }(UIPageControl())
    
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
    
    private var items: [String] = [] {
        didSet {
            pageIndicator.numberOfPages = items.count
            collectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    private func setupView() {
        addSubview(collectionView)
        addSubview(pageIndicator)
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pageIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-8)
        }
        
        snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.width * 0.733)
        }
    }
    
    //MARK: - Private Objc Methods
    @objc
    private func didChangePage(control: UIPageControl) {
        collectionView.scrollToItem(
            at: .init(row: control.currentPage, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
    }
    
    //MARK: - Public Methods
    func set(data: [String]) {
        items = data
    }
}

//MARK: - PhotoCollectionView: UICollectionViewDelegate
extension PhotoCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageIndicator.currentPage = indexPath.row
    }
}

//MARK: - PhotoCollectionView: UICollectionViewDataSource
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
