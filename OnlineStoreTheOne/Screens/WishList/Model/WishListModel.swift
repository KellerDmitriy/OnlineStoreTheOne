//
//  WishListModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 20.04.2024.
//

import Foundation
import RealmSwift

final class WishListModel: Object, StorableItem {
    @Persisted var id: Int
    @Persisted var isSelected: Bool
    @Persisted var title: String
    @Persisted var price: Int
    @Persisted var images: List<Data>
}

