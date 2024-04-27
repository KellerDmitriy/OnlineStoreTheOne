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
    
    // MARK: - CRUD Operations
    
    func isItemSaved<T: Object>(_ itemType: T.Type, id: Int) -> Bool {
        let itemsWithId = realm.objects(itemType).filter("id = %@", id)
        return itemsWithId.isEmpty
    }
    
    func addItem<T: Object>(_ itemType: T.Type, _ item: Products, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let imageUrlString = item.images?.first else {
            completion(.failure(StorageError.noImageURLFound))
            return
        }
        
        guard let imageUrl = correctedURL(from: imageUrlString) else {
            completion(.failure(StorageError.noImageURLFound))
            return
        }
        
        KingfisherManager.shared.retrieveImage(with: imageUrl) { result in
            switch result {
            case .success(let imageResult):
                if let imageData = imageResult.image.pngData() {
                    do {
                        try self.realm.write {
                            let newItem = T()
                            if let newItem = newItem as? StorableItem {
                                newItem.id = item.id
                                newItem.title = item.title
                                newItem.price = item.price
                                newItem.images.append(imageData)
                                self.realm.add(newItem)
                                completion(.success(()))
                            } else {
                                completion(.failure(StorageError.invalidItemType))
                            }
                        }
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(StorageError.imageConversionFailed))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateItem<T: Object>(_ itemType: T.Type, id: Int, updateBlock: @escaping (T?) -> Void) {
        do {
            guard let item = realm.object(ofType: itemType, forPrimaryKey: id) else {
                print("Item not found")
                return
            }
            try realm.write {
                updateBlock(item)
            }
        } catch {
            print("Error updating item: \(error)")
        }
    }
    
    func deleteCarts() {
            try! realm.write {
                let allCarts = realm.objects(CartsModel.self)
                realm.delete(allCarts)
            }
        }

    
    func removeItem<T: Object>(_ itemType: T.Type, id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            guard let item = realm.object(ofType: itemType, forPrimaryKey: id) else {
                completion(.failure(StorageError.itemNotFound))
                return
            }
            try realm.write {
                realm.delete(item)
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - correctedURL
    func correctedURL(from urlString: String) -> URL? {
        let trimmed = urlString
            .data(using: .utf8)
            .flatMap { try? JSONSerialization.jsonObject(with: $0) }
            .flatMap { $0 as? [String] }
            .flatMap(\.first)
            .flatMap(URL.init)
        
        if let trimmedUrl = trimmed {
            return trimmedUrl
        } else {
            return URL(string: urlString)
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
}
