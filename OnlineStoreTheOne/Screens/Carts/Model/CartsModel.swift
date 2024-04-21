//
//  CartsModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 21.04.2024.
//

import Foundation
import RealmSwift

final class CartsModel: Object {
    
    @Persisted var id: Int
    @Persisted var title: String
    @Persisted var price: Int
    @Persisted var itemDescription: String?
    @Persisted var category: String?
    @Persisted var images: List<Data>
}
