//
//  HomeViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 19.04.2024.
//


import Foundation
import Combine

enum DataError: Error {
    case productsError(NetworkError)
    case categoriesError(NetworkError)
    
    var localizedDescription: String {
        switch self {
        case .productsError(let error):
            return "Products Error: \(error.localizedDescription)"
        case .categoriesError(let error):
            return "Categories Error: \(error.localizedDescription)"
        }
    }
}

final class HomeViewModel: ObservableObject {
    @Published var dataError: DataError?
    
    @Published var productCount = 1
    @Published var isCategoryExpanded = false
    
    @Published var isLoading: Bool = true
    @Published var categories: [Category] = []
    @Published var products: [Products] = []
    @Published var productsForCategory: [Products] = []
    @Published var searchedProducts: [Products] = []
    
    //    @Published var idsForCart: [Int] = []
    @Published var searchText = ""
    
    @Published var selectedCategory: Int?  = nil
    
    var subscription: Set<AnyCancellable> = []
    
    let networkService: NetworkServiceProtocol
    let storageService: StorageServiceProtocol
    
    //MARK: - Init
    init(networkService: NetworkServiceProtocol, storageService: StorageServiceProtocol) {
        self.networkService = networkService
        self.storageService = storageService
        
        observe()
    }
    
    //MARK: - Observe Methods
    private func observe() {
        $searchText
            .sink {  searchText in
            }
            .store(in: &subscription)
        
        $selectedCategory
            .sink { [weak self] categoryId in
                self?.selected(categoryID: categoryId ?? 1)
            }
            .store(in: &subscription)
    }
    
    //MARK: - Fetch Methods
    func updateCategory(_ id: Int) {
        selectedCategory = id
    }
    
    func toggleCategoryExpansion() {
        isCategoryExpanded.toggle()
    }
    
    func fetchProducts() {
        Task {
            let result = await networkService.fetchAllProducts()
            switch result {
            case .success(let products):
                self.isLoading = false
                self.products = products
                self.productsForCategory = products
            case .failure(let error):
                print(error)
                self.dataError = .productsError(error)
            }
        }
    }
    
    func fetchCategories() {
        Task {
            let result = await networkService.fetchAllCategories()
            switch result {
            case .success(let categories):
                let filteredCategories = filterCategories(categories)
                let uniqueCategories = filterUniqueCategories(filteredCategories)
                self.categories = uniqueCategories
            case .failure(let error):
                print(error)
                self.dataError = .categoriesError(error)
            }
        }
    }
    
    func selected(categoryID: Int) {
        productsForCategory = []
        productsForCategory = products.filter { $0.category?.id == categoryID }
    }
    
    //MARK: - Storage Methods
    func addToCart(_ productId: Int) {
        if let product = products.first(where: { $0.id == productId }) {
            let cartItem = CartModel(product: product, countProduct: 1, isSelected: true)
            
            storageService.saveOrUpdateCart(cartItem)
        }
    }
}

//MARK: - Helper Methods
extension HomeViewModel {
    func filterCategories(_ categories: [Category]) -> [Category] {
        return categories.filter { category in
            if let name = category.name, name != "New Category" {
                return name.count <= 15
            }
            return false
        }
    }
    
    func filterUniqueCategories(_ categories: [Category]) -> [Category] {
        var uniqueCategories: [Category] = []
        var seenNames: Set<String> = Set()
        for category in categories {
            if let name = category.name, !seenNames.contains(name) {
                uniqueCategories.append(category)
                seenNames.insert(name)
            }
        }
        return uniqueCategories
    }
}
//MARK: - HeaderProductsDelegate
extension HomeViewModel: HeaderProductsDelegate {
    func choseFiltration(filterType: ProductFilter) {
        switch filterType {
        case .nameAlphabet:
            productsForCategory.sort { $0.title.localizedCompare($1.title) == .orderedAscending}
        case .priceDescending:
            productsForCategory.sort { $0.price > $1.price }
        case .priceAscending:
            productsForCategory.sort { $0.price < $1.price }
        case .noFilter:
            productsForCategory = products.filter { $0.category?.id == selectedCategory }
        }
    }
}
