//
//  RealmStorageService + Extension.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 21.04.2024.
//

import Foundation

extension RealmStorageService {
    func createCompletion<T: StorableItem>(with itemType: T.Type, for product: Products, completion: @escaping (Result<Void, Error>) -> Void) -> (() -> ()) {
        let closure = {
            if RealmStorageService.shared.isItemSaved(itemType, id: product.id) {
                RealmStorageService.shared.removeItem(itemType, id: product.id, completion: completion)
            } else {
                RealmStorageService.shared.addItem(itemType, product, completion: completion)
            }
        }
        return closure
    }
}
