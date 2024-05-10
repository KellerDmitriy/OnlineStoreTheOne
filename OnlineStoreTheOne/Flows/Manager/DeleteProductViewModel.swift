//
//  DeleteProductViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 28.04.2024.
//

import Foundation
import Combine

final class DeleteProductViewModel {
    @Published var id: String = "-"
    @Published var title: String = "-"
    @Published var price: String = "-"
    
    let networkService: NetworkServiceProtocol
    
    //MARK: - Init
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
     func findProductByTitle(_ title: String) {
         Task {
        let result = await networkService.fetchAllProducts()
             switch result {
             case .success(let products):
                 let filteredProducts = products.filter { $0.title.lowercased().contains(title.lowercased()) }
                 if let firstProduct = filteredProducts.first {
                   id = "\(firstProduct.id)"
                   self.title = firstProduct.title
                   price = "\(firstProduct.price)"
                     print("Найден продукт: \(firstProduct.title) с ID: \(firstProduct.id)")
                 } else {
                     print("Продукт с названием '\(title)' не найден.")
                    id = "-"
                    price = "_"
                    self.title = "-"
                 }
             case .failure(let error):
                 print("Ошибка при запросе продуктов: \(error)")
             }
        }
    }
    
    func deleteProduct() {
        Task {
            guard let id = Int(id) else { return }
            
            let result = await networkService.deleteProductById(id)
            switch result {
            case .success():
                print("Product successfully deleted.")
            case .failure(let error):
                print("Failed to delete product: \(error)")
            }
        }
    }
}
