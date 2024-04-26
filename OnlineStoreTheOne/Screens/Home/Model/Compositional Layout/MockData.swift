//
//  MockData.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 15.04.2024.
//

import Foundation

struct MockData {
    
    static let shared = MockData()
    
    private let searchField: ListSection = {
        .searchField([.init(image: "", categories: "", products: "", title: "", price: "")])
    }()
    
    private let categories: ListSection = {
        .categories([.init(image: "clothes", categories: "Clothers", products: "", title: "", price: ""),

        ])
    }()
        
    private let products: ListSection = {
        .products([.init(image: "tv", categories: "", products: "", title: "tv LG", price: "$199.99"),
                   .init(image: "mug", categories: "", products: "", title: "Aestechic mug", price: "$19.99"),
                   .init(image: "airpoods", categories: "", products: "", title: "Airpoods pro", price: "$499.99")

        ])
    }()
    
    var pageData: [ListSection] {
        [searchField, categories, products]
    }
}

