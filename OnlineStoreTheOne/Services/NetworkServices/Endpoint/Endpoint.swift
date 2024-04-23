//
//  Endpoints.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 15.04.2024.
//

import Foundation

/// Структура, представляющая конечную точку (endpoint) для сетевого запроса.
struct Endpoint {
    
    //MARK: - Private properties
    
    /// HTTP метод для запроса.
    private let method: HTTPMethod
    
    /// Путь запроса.
    private let path: String
                       
    /// Параметры запроса.
    private let queryItems: [URLQueryItem]
    
    //MARK: - Initialization
    
    /// Инициализатор конечной точки с заданными параметрами.
    /// - Parameters:
    ///   - method: HTTP метод запроса (по умолчанию GET).
    ///   - path: Путь запроса (по умолчанию пустая строка).
    ///   - queryItems: Параметры запроса (по умолчанию пустой массив).
    init(
        method: HTTPMethod = .GET,
        path: String = .init(),
        queryItems: [URLQueryItem] = .init()
    ) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
    }
    
    /// Инициализатор конечной точки с заданными параметрами, используя builder для параметров запроса.
    /// - Parameters:
    ///   - method: HTTP метод запроса (по умолчанию GET).
    ///   - path: Путь запроса (по умолчанию пустая строка).
    ///   - builder: Замыкание для построения параметров запроса.
    init(
        method: HTTPMethod = .GET,
        path: String = .init(),
        @QueryItemBuilder builder: () -> [URLQueryItem]
    ) {
        self.method = method
        self.path = path
        self.queryItems = builder()
    }
    
    //MARK: - Public methods
    
    /// Преобразует конечную точку в URL-запрос.
    var urlRequest: URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.escuelajs.co"
        components.path = "/api/v1/".appending(path)
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure("Unable to create url from: \(components)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        print(request)
        return request
    }
}

extension Endpoint {
    
    /// Добавляет новый путь к существующему.
    func path(_ p: String) -> Self {
        Endpoint(method: method, path: p, queryItems: queryItems)
    }
    
    /// Устанавливает новый HTTP метод.
    func method(_ m: HTTPMethod) -> Self {
        Endpoint(method: m, path: path, queryItems: queryItems)
    }
    
    /// Добавляет новые параметры запроса с использованием builder.
    func queryItems(@QueryItemBuilder _ builder: () -> [URLQueryItem]) -> Self {
        Endpoint(method: method, path: path) {
            queryItems
            builder()
        }
    }
}

extension Endpoint {
    
    /// Поддерживаемые HTTP методы запросов.
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
}

/// Билдер для построения параметров запроса.
@resultBuilder
enum QueryItemBuilder {
    
    /// Строит блок из массива URLQueryItem.
    static func buildBlock(_ components: URLQueryItem...) -> [URLQueryItem] {
        components
    }
    
    /// Строит блок из массивов URLQueryItem.
    static func buildBlock(_ components: [URLQueryItem]...) -> [URLQueryItem] {
        components.flatMap { $0 }
    }
    
    /// Строит блок из опционального массива URLQueryItem.
    static func buildOptional(_ component: [URLQueryItem]?) -> [URLQueryItem] {
        component ?? []
    }
}
