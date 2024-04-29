//
//  UpdateProductViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 28.04.2024.
//

import Foundation

final class UpdateProductViewModel {
    var id: Int?
    var title: String?
    var price: Int?
    
    var productUpdate: ProductUpdate? {
        guard
            let id,
            let title,
            let price
        else { return nil }
        
        let product = ProductUpdate(
            title: title,
            price: price
        )
        
        return product
    }
}
