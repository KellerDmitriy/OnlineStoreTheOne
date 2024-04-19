//
//  MainViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 19.04.2024.
//

import Foundation

final class MainViewModel {
    
    var products: [Products] = []
    var categories: [Category] = []
    
    let networkService = NetworkService.shared
    
    func fetchProducts() {
        Task {
            do {
                let result: Result<[Products], NetworkError> = await networkService.fetchAllProducts()
                
                if case let .success(data) = result {
                    self.products = data
                } else if case let .failure(error) = result {
                    print("Failed to fetch data: \(error)")
                }
            } catch {
                print("Failed to fetch data: \(error)")
    
            }
        }
    }
    
    func fetchCategory() {
        Task {
            do {
                let result: Result<[Category], NetworkError> = await networkService.fetchCategory()
                
                if case let .success(data) = result {
                    self.categories = data
                } else if case let .failure(error) = result {
                    print("Failed to fetch data: \(error)")
                }
            } catch {
                print("Failed to fetch data: \(error)")
            }
        }
    }
    
    
}
