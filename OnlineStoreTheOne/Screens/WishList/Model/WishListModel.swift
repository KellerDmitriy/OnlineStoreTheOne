//
//  WishListModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 20.04.2024.
//

import Foundation
import RealmSwift

final class WishListModel: Object {
    
    @Persisted var id: Int
    @Persisted var title: String
    @Persisted var price: Int
    @Persisted var itemDescription: String?
    @Persisted var category: String?
    @Persisted var images: List<Data>
}

