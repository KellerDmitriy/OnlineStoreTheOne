//
//  CartModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 03.05.2024.
//

import Foundation

struct CartModel: Codable {
    let product: Products
    var countProduct = 1
    var isSelected = true
}
