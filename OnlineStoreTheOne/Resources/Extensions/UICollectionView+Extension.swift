//
//  UICollectionView+Extension.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 21.04.2024.
//

import UIKit

// MARK: - reuseID
extension UICollectionViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }

    open override var reuseIdentifier: String {
        type(of: self).reuseIdentifier
    }
}

extension UICollectionReusableView {
    static var headerIdentifier: String {
        String(describing: self)
    }
    
    static var footerIdentifier: String {
        String(describing: self)
    }
}

extension UICollectionView {
    // Register cell
    func register<T: UICollectionViewCell>(_ type: T.Type) {
        register(type.self, forCellWithReuseIdentifier: type.reuseIdentifier)
    }

    // Dequeue cell
    func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell of type \(T.self)")
        }
        return cell
    }

    // Register header
    func registerHeader<T: UICollectionReusableView>(_ supplementaryViewType: T.Type) {
        register(supplementaryViewType.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.headerIdentifier)
    }

    // Dequeue header
    func dequeueReusableHeader<T: UICollectionReusableView>(type: T.Type, for indexPath: IndexPath) -> T {
        guard let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.headerIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a header of type \(T.self)")
        }
        return header
    }
    
    // Register footer
    func registerFooter<T: UICollectionReusableView>(_ supplementaryViewType: T.Type) {
        register(supplementaryViewType.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.footerIdentifier)
    }

    // Dequeue footer
    func dequeueReusableFooter<T: UICollectionReusableView>(type: T.Type, for indexPath: IndexPath) -> T {
        guard let footer = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.footerIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a footer of type \(T.self)")
        }
        return footer
    }
}
