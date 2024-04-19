//
//  ProductsModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 15.04.2024.
//

import Foundation

// MARK: - Products
struct Products: Codable {
    let id: Int
    let title: String
    let price: Int
    let description: String?
    let category: Category?
    let images: [String]?
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name: String?
    let image: String?
}
