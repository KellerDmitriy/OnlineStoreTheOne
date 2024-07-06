//
//  IdentifiableCell.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 21.04.2024.
//

import UIKit

protocol IdentifiableCell {
    static var reuseId: String { get }
}

extension IdentifiableCell {
    static var reuseId: String { "\(self)"}
}

extension UICollectionViewCell: IdentifiableCell {}


