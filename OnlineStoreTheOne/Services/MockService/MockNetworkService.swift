//
//  MockNetworkService.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 21.07.2024.
//

import Foundation

final class MockNetworkService: NetworkServiceProtocol, Mockable {
    
    func fetchAllProducts() async -> Result<[Products], NetworkError> {
        let data = getJSON(fileName: "AllProducts", type: [Products].self)
        return .success(data)
    }
    
    func fetchAllCategories() async -> Result<[Category], NetworkError> {
        let data = getJSON(fileName: "AllCategories", type: [Category].self)
        return .success(data)
    }
    
    func fetchProducts(with categoryID: Int?) async -> Result<[Products], NetworkError> {
        let data = getJSON(fileName: "ProductsByCategory", type: [Products].self)
        return .success(data)
    }
    
    func fetchSingleProduct(for id: Int) async -> Result<Products, NetworkError> {
        let data = getJSON(fileName: "SingleProduct", type: Products.self)
        return .success(data)
    }
    
    func fetchSearchProducts(_ searchText: String) async -> Result<[Products], NetworkError> {
        let data = getJSON(fileName: "SearchProducts", type: [Products].self)
        return .success(data)
    }
    
    func createProduct(product: Product) async -> Result<MyProductResponse, NetworkError> {
        let data = getJSON(fileName: "CreateProductResponse", type: MyProductResponse.self)
        return .success(data)
    }
    
    func updateProduct(id: Int, updateData: ProductUpdate) async -> Result<Void, NetworkError> {
        return .success(())
    }
    
    func deleteProductById(_ id: Int) async -> Result<Void, NetworkError> {
        return .success(())
    }
    
    func createCategory(category: NewCategory) async -> Result<NewCategory, NetworkError> {
        let data = getJSON(fileName: "CreateCategoryResponse", type: NewCategory.self)
        return .success(data)
    }
    
    func updateCategory(id: Int, updateData: CategoryUpdate) async -> Result<Void, NetworkError> {
        return .success(())
    }
    
    func deleteCategory(id: Int) async -> Result<Void, NetworkError> {
        return .success(())
    }
}
