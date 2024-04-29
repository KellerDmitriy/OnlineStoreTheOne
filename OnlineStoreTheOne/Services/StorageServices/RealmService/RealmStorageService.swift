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
    
    func addProductToCart(_ product: Products, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let imageUrlString = product.images?.first else {
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
                    self.write {
                        if let existingItem = self.realm.objects(CartsModel.self).filter("id == %@", product.id).first {
                            existingItem.countProduct += 1
                        } else {
                            let newItem = CartsModel()
                            newItem.id = product.id
                            newItem.title = product.title
                            newItem.price = product.price
                            newItem.images.append(imageData)
                            self.realm.add(newItem)
                        }
                    }
                    completion(.success(()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateItem<T: Object>(_ itemType: T.Type, id: Int, updateBlock: @escaping (T?) -> Void) {
        guard let item = realm.objects(itemType).filter("id == %@", id).first else {
            print("Item not found")
            return
        }
        self.write {
            updateBlock(item)
        }
    }
    
    func removeItem<T: Object>(_ itemType: T.Type, id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let item = realm.objects(itemType).filter("id == %@", id).first else {
                completion(.failure(StorageError.itemNotFound))
                return
            }
        write {
            realm.delete(item)
            completion(.success(()))
        }
    }
    
    func deleteAllProducts<T: Object>(_ itemType: T.Type) {
        write {
            let allProducts = realm.objects(itemType)
            realm.delete(allProducts)

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
     func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print(error)
        }
    }
}
