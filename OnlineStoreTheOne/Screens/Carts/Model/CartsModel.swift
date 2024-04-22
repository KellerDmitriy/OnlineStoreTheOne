//
//  CartsModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 21.04.2024.
//

import Foundation
import RealmSwift

final class CartsModel: Object, StorableItem {
    
    @Persisted var id: Int
    @Persisted var title: String
    @Persisted var price: Int
    @Persisted var countProduct: Int 
    @Persisted var images: List<Data>
}
