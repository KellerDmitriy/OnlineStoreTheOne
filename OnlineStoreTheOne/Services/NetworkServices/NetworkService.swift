//
//  NetworkService.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 15.04.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchAllProducts() async -> Result<[Products], NetworkError>
    func fetchAllCategories() async -> Result<[Category], NetworkError>
    
    func fetchProducts(with categoryID: Int?) async -> Result<[Products], NetworkError>
    func fetchSingleProduct(for id: Int) async -> Result<Products, NetworkError>
    func fetchSearchProducts(_ searchText: String) async -> Result<[Products], NetworkError>
    
    func createProduct(product: Product) async -> Result<MyProductResponse, NetworkError>
    func updateProduct(id: Int, updateData: ProductUpdate) async -> Result<Void, NetworkError>
    func deleteProductById(_ id: Int) async -> Result<Void, NetworkError>
    func createCategory(category: NewCategory) async -> Result<NewCategory, NetworkError>
    func updateCategory(id: Int, updateData: CategoryUpdate) async -> Result<Void, NetworkError>
    func deleteCategory(id: Int) async -> Result<Void, NetworkError>
}

/// Сервис для выполнения сетевых запросов.
final class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Properties
    
    /// Сессия URLSession для выполнения сетевых запросов.
    let session = URLSession.shared
    
    /// Декодер JSON для декодирования полученных данных.
    let decoder = JSONDecoder()
    
    // MARK: - Public Methods
    /// Получение всех продуктов из сети.
    /// - Returns: Результат выполнения запроса с массивом продуктов или ошибкой сети.
    func fetchAllProducts() async -> Result<[Products], NetworkError> {
            await request(from: .allProducts())
                .mapError(NetworkError.init)
        }
    /// Получение всех категорий
    func fetchAllCategories() async -> Result<[Category], NetworkError> {
        await request(from: .allCategories())
            .mapError(NetworkError.init)
    }

    /// Получение всех продуктов из сети по категориям.
    func fetchProducts(with categoryID: Int?) async -> Result<[Products], NetworkError> {
        await request(from: .products(with: categoryID))
            .mapError(NetworkError.init)
    }
    
    /// Получение одного продукта из сети по ключу.
    func fetchSingleProduct(for id: Int) async -> Result<Products, NetworkError> {
        await request(from: .singleProduct(for: id))
            .mapError(NetworkError.init)
    }
    
    /// Получение продуктов по названию
    func fetchSearchProducts(_ searchText: String) async -> Result<[Products], NetworkError> {
        await request(from: .searchProducts(with: searchText))
            .mapError(NetworkError.init)
    }
    
    func createProduct(product: Product) async -> Result<MyProductResponse, NetworkError> {
        let endpoint = Endpoint.createProduct()
        return await sendRequest(to: endpoint, with: product)
    }
    
    func updateProduct(id: Int, updateData: ProductUpdate) async -> Result<Void, NetworkError> {
        let endpoint = Endpoint.updateProduct(id: id)
        return await sendRequest(to: endpoint, with: updateData)
    }
    
    func deleteProductById(_ id: Int) async -> Result<Void, NetworkError> {
        let endpoint = Endpoint.deleteProduct(id: id)
        return await sendRequest(to: endpoint)
    }
    
    func createCategory(category: NewCategory) async -> Result<NewCategory, NetworkError> {
        let endpoint = Endpoint.createCategory()
        return await sendRequest(to: endpoint, with: category)
    }
    
    func updateCategory(id: Int, updateData: CategoryUpdate) async -> Result<Void, NetworkError> {
        let endpoint = Endpoint.updateCategory(id: id)
        return await sendRequest(to: endpoint, with: updateData)
    }
    
    func deleteCategory(id: Int) async -> Result<Void, NetworkError> {
        let endpoint = Endpoint.deleteCategory(id: id)
        return await sendRequest(to: endpoint)
    }
    
    private func sendRequest<T: Encodable, U: Decodable>(to endpoint: Endpoint, with body: T) async -> Result<U, NetworkError> {
        do {
            var request = endpoint.urlRequest
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)

            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                throw NetworkError.invalidResponse
            }
            let decodedResponse = try decoder.decode(U.self, from: data)
            return .success(decodedResponse)
        } catch {
            return .failure(NetworkError.noData)
        }
    }
    
    private func sendRequest<T: Encodable>(to endpoint: Endpoint, with body: T) async -> Result<Void, NetworkError> {
        do {
            var request = endpoint.urlRequest
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)

            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return .failure(.invalidResponse)
            }
            return .success(())
        } catch {
            return .failure(NetworkError.noData)
        }
    }
    
    private func sendRequest(to endpoint: Endpoint) async -> Result<Void, NetworkError> {
        do {
            var request = endpoint.urlRequest
            request.httpMethod = "DELETE"
            
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return .failure(.invalidResponse)
            }
            return .success(())
        } catch {
            return .failure(NetworkError.noData)
        }
    }
}

extension NetworkService {
    
    // MARK: - Request Methods
    
    /// Выполнение сетевого запроса к указанному endpoint.
    /// - Parameter endpoint: Endpoint для выполнения запроса.
    /// - Returns: Результат выполнения запроса с декодированными данными или ошибкой сети.
    func request<T: Decodable>(from endpoint: Endpoint) async -> Result<T, Error> {
        await Result
            .success(endpoint)
            .map(\.urlRequest)
            .asyncMap(session.data)
            .flatMap(unwrapResponse)
            .decode(T.self, decoder: decoder)
    }
    
    // MARK: - Response Handling
    
    /// Обработка ответа от сервера и извлечение данных.
    /// - Parameter dataResponse: Кортеж с данными ответа и объектом URLResponse.
    /// - Returns: Результат с извлеченными данными или ошибкой сети.
    func unwrapResponse(_ dataResponse: (Data, URLResponse)) -> Result<Data, Error> {
        guard let httpResponse = dataResponse.1 as? HTTPURLResponse else {
            return .failure(NetworkError.invalidResponse)
        }
        
        switch httpResponse.statusCode {
        case 200:
            return .success(dataResponse.0)
        case 400:
            return .failure(
                NetworkError.serverError(statusCode: 400,
                description: "Parameter missing")
            )
        case 401:
            return .failure(
                NetworkError.serverError(statusCode: 401,
                description: "Unauthorized")
            )
        case 403:
            return .failure(
                NetworkError.serverError(statusCode: 403,
                description: "CORS policy failed. IP/Domain restricted")
            )
        case 409:
            return .failure(
                NetworkError.serverError(statusCode: 409,
                description: "Parameter duplicate")
            )
        case 415:
            return .failure(
                NetworkError.serverError(statusCode: 415,
                description: "Unsupported type")
            )
        case 422:
            return .failure(
                NetworkError.serverError(statusCode: 422,
                description: "Unprocessable entity")
            )
        case 429:
            return .failure(
                NetworkError.serverError(statusCode: 429,
                description: "Too many requests")
            )
        case 500:
            return .failure(
                NetworkError.serverError(statusCode: 500,
                description: "Internal server error")
            )
        default:
            return .failure(NetworkError.invalidResponse)
        }
    }
}
