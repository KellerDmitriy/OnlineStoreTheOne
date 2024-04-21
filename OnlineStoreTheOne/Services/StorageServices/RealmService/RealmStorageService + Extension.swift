//
//  RealmStorageService + Extension.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 21.04.2024.
//

import Foundation

extension RealmStorageService {
    func createCompletion(with wishList: Products, imagesData: Data) -> (() -> ()) {
        let closure = {
            if RealmStorageService.shared.isItemSaved(withId: wishList.id) {
                RealmStorageService.shared.removeFromWishList(wishList.id)
            } else {
                RealmStorageService.shared.addToWishList(wishList, imagesData: [imagesData])
            }
        }
        return closure
    }
}
