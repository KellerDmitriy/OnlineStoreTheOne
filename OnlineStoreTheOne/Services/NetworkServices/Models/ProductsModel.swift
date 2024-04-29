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
    let image: String?
    let images: [String]?
    
    static var placeholder: Self {
        return Products(
            id: 1,
            title: "",
            price: 2,
            description: "",
            category: Category.init(
                id: 2, name: "", image: ""),
            image: "",
            images: [""]
        )
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name: String?
    let image: String?
}
