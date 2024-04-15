//
//  Endpoints.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 15.04.2024.
//

import Foundation

struct Endpoint {
    //MARK: - Private properties
    private let method: HTTPMethod
    private let path: String
    private let queryItems: [URLQueryItem]
    
    //MARK: - init(_:)
    init(
        method: HTTPMethod = .GET,
        path: String = .init(),
        queryItems: [URLQueryItem] = .init()
    ) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
    }
    
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
    func path(_ p: String) -> Self {
        Endpoint(method: method, path: p, queryItems: queryItems)
    }
    
    func method(_ m: HTTPMethod) -> Self {
        Endpoint(method: m, path: path, queryItems: queryItems)
    }
    
    func queryItems(@QueryItemBuilder _ builder: () -> [URLQueryItem]) -> Self {
        Endpoint(method: method, path: path) {
            queryItems
            builder()
        }
    }
}

extension Endpoint {
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
}

@resultBuilder
enum QueryItemBuilder {
    static func buildBlock(_ components: URLQueryItem...) -> [URLQueryItem] {
        components
    }
    
    static func buildBlock(_ components: [URLQueryItem]...) -> [URLQueryItem] {
        components.flatMap { $0 }
    }
    
    static func buildOptional(_ component: [URLQueryItem]?) -> [URLQueryItem] {
        component ?? []
    }
}
