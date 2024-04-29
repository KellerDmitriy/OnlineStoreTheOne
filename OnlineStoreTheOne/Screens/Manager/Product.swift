//
//  Product.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 28.04.2024.
//

import Foundation

struct Product: Codable {
    var title: String
    var price: Int
    var description: String
    var categoryId: Int
    var images: [String]
}

struct MyProductResponse: Codable {
    var title: String
    var price: Double
    var description: String
    var images: [String]
    var category: Category
    var id: Int
    var creationAt: String
    var updatedAt: String
}
