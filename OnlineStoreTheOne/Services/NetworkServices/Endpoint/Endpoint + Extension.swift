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
            .path("products")
            .queryItems {
                URLQueryItem(name: "title", value: searchText)
            }
    }
    
    static func createProduct() -> Self {
            Endpoint(method: .POST, path: "products")
        }
    
    static func updateProduct(id: Int) -> Self {
            Endpoint(method: .PUT, path: "products/\(id)")
        }
    
    static func deleteProduct(id: Int) -> Self {
            Endpoint(method: .DELETE, path: "products/\(id)")
        }
    
    static func createCategory() -> Self {
           Endpoint(method: .POST, path: "categories")
       }
    
    static func updateCategory(id: Int) -> Self {
            Endpoint(method: .PUT, path: "categories/\(id)")
        }
    
    static func deleteCategory(id: Int) -> Self {
            Endpoint(method: .DELETE, path: "categories/\(id)")
        }
}

