//
//  RealmStorageService.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 20.04.2024.
//

import Foundation
import RealmSwift
import Kingfisher

final class RealmStorageService {
    static let shared = RealmStorageService()
    
    let realm: Realm
    
    //MARK: - Init
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    // MARK: - CRUD for WishList
    
    func addToWishList(_ wishList: Products) {
        guard let imageUrlString = wishList.images?.first, let imageUrl = URL(string: imageUrlString) else {
            print("No image URL found")
            return
        }
        
        KingfisherManager.shared.retrieveImage(with: imageUrl) { result in
            switch result {
            case .success(let imageResult):
                if let imageData = imageResult.image.pngData() {
                    let wishListModel = WishListModel()
                    wishListModel.id = wishList.id
                    wishListModel.title = wishList.title
                    wishListModel.price = wishList.price
                    wishListModel.itemDescription = wishList.description
                    wishListModel.category = wishList.category?.name
                    wishListModel.images.append(imageData)
                    
                    do {
                        try self.realm.write {
                            self.realm.add(wishListModel)
                        }
                        print("Successfully added to wishlist")
                    } catch {
                        print("Error adding to wishlist: \(error)")
                    }
                } else {
                    print("Failed to convert image to data")
                }
            case .failure(let error):
                print("Failed to retrieve image: \(error)")
            }
        }
    }
    
    func removeFromWishList(_ wishListId: Int) {
        do {
            guard let wishListModel = realm.object(ofType: WishListModel.self, forPrimaryKey: wishListId) else {
                print("WishListModel with id \(wishListId) not found.")
                return
            }
            try realm.write {
                realm.delete(wishListModel)
            }
        } catch {
            print("Error removing from wishlist: \(error)")
        }
    }
    
    
    
    // MARK: - CRUD for WishList
    
    func addToCart(_ carts: [CartsModel]) {
        write {
            realm.add(carts)
        }
    }
    
    // MARK: - Write
    private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - isItemSaved
    func isItemSaved(withId id: Int) -> Bool {
        let itemsWithId = realm.objects(WishListModel.self).filter("id = %@", id)
        return !itemsWithId.isEmpty
    }
}
