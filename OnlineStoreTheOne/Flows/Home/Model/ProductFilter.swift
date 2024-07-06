//
//  ProductFilter.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 26.05.2024.
//

import Foundation

enum ProductFilter: CaseIterable {
    case nameAlphabet
    case priceDescending
    case priceAscending
    case noFilter
}

extension ProductFilter{
    var typeFilterLabel: String {
        switch self {
        case .nameAlphabet:
            return "Name Alphabet"
        case .priceDescending:
            return "Price Descending"
        case .priceAscending:
            return "Price Ascending"
        case .noFilter:
            return "Switch Of Filter"
        }
    }
}
