//
//  NetworkService.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 15.04.2024.
//

import Foundation


/// Сервис для выполнения сетевых запросов.
final class NetworkService {
    
    // MARK: - Properties
    
    /// Общий экземпляр сетевого сервиса.
    public static let shared = NetworkService()
    
    /// Сессия URLSession для выполнения сетевых запросов.
    let session = URLSession.shared
    
    /// Декодер JSON для декодирования полученных данных.
    let decoder = JSONDecoder()
    
    // MARK: - Initialization
    
    /// Приватный инициализатор для предотвращения создания экземпляров снаружи класса.
    private init () {}
    
    // MARK: - Public Methods
    
    /// Получение всех продуктов из сети.
    /// - Returns: Результат выполнения запроса с массивом продуктов или ошибкой сети.
    func fetchAllProducts() async -> Result<[Products], NetworkError> {
        await request(from: .allProducts())
            .mapError(NetworkError.init)
    }
    /// Получение всех категорий 
    func fetchAllCategory() async -> Result<[Category], NetworkError> {
        await request(from: .allCategories())
            .mapError(NetworkError.init)
    }
    
    var category = "https://api.escuelajs.co/api/v1/categories"
    
    func fetchCategory() async -> Result<[Category], NetworkError> {
        await request(from: .allCategories())
            .mapError(NetworkError.init)
    }
    
//    /// Получение всех продуктов из сети по категориям.
//    func fetchProducts(with category: Category) async -> Result<[Products], NetworkError> {
//        await request(from: .products(with: category.id))
//            .mapError(NetworkError.init)
//    }
    /// Получение всех продуктов из сети по категориям.
    func fetchProducts(with category: Category) async -> Result<[Products], NetworkError> {
        await request(from: .products(with: category.id))
            .mapError(NetworkError.init)
    }
    /// Получение всех продуктов из сети по категориям.
    func fetchProducts(for id: Int) async -> Result<Products, NetworkError> {
        await request(from: .products(for: id))
            .mapError(NetworkError.init)
    }
    
    /// Получение всех продуктов из сети по категориям.
    func fetchSearchProducts(by title: String) async -> Result<[Products], NetworkError> {
        await request(from: .products(for: title))
            .mapError(NetworkError.init)
    }
}

extension NetworkService {
    
    // MARK: - Request Methods
    
    /// Выполнение сетевого запроса к указанному endpoint.
    /// - Parameter endpoint: Endpoint для выполнения запроса.
    /// - Returns: Результат выполнения запроса с декодированными данными или ошибкой сети.
    func request<T: Decodable>(from endpoint: Endpoint) async -> Result<T, Error> {
       print(await Result
        .success(endpoint)
        .map(\.urlRequest)
        .asyncMap(session.data)
        .flatMap(unwrapResponse)
        .decode(T.self, decoder: decoder)
       )
        return await Result
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

//extension NetworkService {
//    func createProduct(product: Product) async -> Result<Void, NetworkError> {
//        let endpoint = Endpoint.createProduct()
//        return await sendRequest(to: endpoint, with: product)
//    }
//
//    private func sendRequest<T: Encodable>(to endpoint: Endpoint, with body: T) async -> Result<Void, NetworkError> {
//        do {
//            var request = endpoint.urlRequest
//            request.httpMethod = "POST"
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = try JSONEncoder().encode(body)
//
//            let (_, response) = try await URLSession.shared.data(for: request)
//            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
//                throw NetworkError.invalidResponse
//            }
//            return .success(())
//        } catch {
//            return .failure(NetworkError.noData)
//        }
//    }
//}

extension NetworkService {
    func createProduct(product: Product) async -> Result<MyProductResponse, NetworkError> {
        let endpoint = Endpoint.createProduct()
        return await sendRequest(to: endpoint, with: product)
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
}

extension NetworkService {
    func updateProduct(id: Int, updateData: ProductUpdate) async -> Result<Void, NetworkError> {
        let endpoint = Endpoint.updateProduct(id: id)
        return await sendRequest(to: endpoint, with: updateData)
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
}

extension NetworkService {
    func deleteProductById(_ id: Int) async -> Result<Void, NetworkError> {
        let endpoint = Endpoint.deleteProduct(id: id)
        return await sendRequest(to: endpoint)
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
