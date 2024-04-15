//
//  Endpoint + Extension.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 15.04.2024.
//

import Foundation

extension Endpoint {
    
    static func get() -> Endpoint { Endpoint(method: .GET) }
    static func post() -> Endpoint {Endpoint(method: .POST) }
    static func put() -> Endpoint { Endpoint(method: .PUT) }
    
    
    static func allProducts() -> Self {
        Endpoint.get()
            .path("products")
    }
}

