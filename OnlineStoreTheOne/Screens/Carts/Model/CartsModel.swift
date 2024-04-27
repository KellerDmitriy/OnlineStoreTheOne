//
//  CartsModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 21.04.2024.
//

import Foundation
import RealmSwift

final class CartsModel: Object, StorableItem {
    @Persisted var value = UUID()
    @Persisted var id: Int
    @Persisted var title: String
    @Persisted var price: Int
    @Persisted var countProduct: Int = 0
    @Persisted var isSelected: Bool = true
    @Persisted var images: List<Data>
}
