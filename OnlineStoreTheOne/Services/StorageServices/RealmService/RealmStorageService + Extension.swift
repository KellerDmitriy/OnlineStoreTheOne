//
//  RealmStorageService + Extension.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 21.04.2024.
//

import Foundation
import RealmSwift

extension RealmStorageService {
    
    func isItemSaved<T: Object>(_ itemType: T.Type, id: Int) -> Bool {
        let itemId = realm.objects(itemType).filter("id = %@", id)
        return !itemId.isEmpty
    }
    
    func addWishList(_ productId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        write {
             let newItem = WishListModel()
                newItem.id = productId
                self.realm.add(newItem)
                completion(.success(()))
        }
    }
}
