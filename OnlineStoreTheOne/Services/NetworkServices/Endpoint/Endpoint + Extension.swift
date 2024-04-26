//
//  Endpoint + Extension.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 15.04.2024.
//

import Foundation

extension Endpoint {
    
    /// Создает конечную точку для HTTP GET запроса.
    static func get() -> Endpoint { Endpoint(method: .GET) }
    
    /// Создает конечную точку для HTTP POST запроса.
    static func post() -> Endpoint { Endpoint(method: .POST) }
    
    /// Создает конечную точку для HTTP PUT запроса.
    static func put() -> Endpoint { Endpoint(method: .PUT) }
    
    /// Создает конечную точку для получения всех категорий
    static func allCategories() -> Self {
        Endpoint.get()
            .path("categories")
    }
    
    /// Создает конечную точку для получения продуктов по категории.
    static func products(with categoryID: Int?) -> Self {
            if let categoryID = categoryID {
                return Endpoint.get()
                    .path("categories/\(categoryID)/products")
            } else {
                return Endpoint.get()
                    .path("products")
            }
        }
    
    /// Создает конечную точку для получения продуктов по Id(для WishList).
    static func singleProduct(for id: Int) -> Self {
        Endpoint.get()
            .path("products/\(id)")
    }
    
    /// Создает конечную точку для получения продуктов по названию
    static func searchProducts(with searchText: String) -> Self {
        Endpoint.get()
            .queryItems {
                URLQueryItem(name: "title", value: searchText)
            }
    }
}

