//
//  DetailsProductViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 21.04.2024.
//

import Foundation
import Combine

final class DetailsProductViewModel {
    @Published var title: String = ""
    @Published var price: String = ""
    @Published var description: String? = ""
    @Published var images: [String]? = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(productId: Int) {
        fetchProductDetails(productId: productId)
    }
    
    private func fetchProductDetails(productId: Int) {
        Task {
            let result = await NetworkService.shared.fetchProducts(for: productId)
            switch result {
            case .success(let model):
                updateProperties(model: model)
            case .failure(let error):
                print("Error fetching products: \(error)")
            }
        }
    }
    
    private func updateProperties(model: Products) {
        title = model.title
        price = "$ \(model.price)"
        description = model.description
        images = model.images
    }
}
