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
    
    /// Создает конечную точку для получения всех продуктов.
    static func allProducts() -> Self {
        Endpoint.get()
            .path("products")
    }
    
    static func products(with categoryID: Int) -> Self {
        Endpoint.get()
            .path("categories/\(categoryID)")
    }
}

