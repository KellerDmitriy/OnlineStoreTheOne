//
//  AddNewProductViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 28.04.2024.
//

import Foundation

final class AddNewProductViewModel {
    var title: String?
    var price: Int?
    var category: Int?
    var description: String?
    var imageOne: String?
    var imageTwo: String?
    var imageThree: String?

    var product: Product? {
        let images = [
            imageOne,
            imageTwo,
            imageThree
        ].compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }

        guard
            let title,
            let price,
            let category,
            let description,
            !images.isEmpty
        else {
            print("Error with create product")
            return nil
        }
        
        let product = Product(
            title: title,
            price: price,
            description: description,
            categoryId: category,
            images: images
        )
        return product
    }
}
