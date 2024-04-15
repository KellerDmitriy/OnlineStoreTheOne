//
//  NetworkService.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 15.04.2024.
//

import Foundation

final class NetworkService {
    public static let shared = NetworkService()
    
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    private init () {}
    
    func fetchAllProducts() async -> Result<[Products], NetworkError> {
        await request(from: .allProducts())
            .mapError(NetworkError.init)
    }
}

extension NetworkService {
    func request<T: Decodable>(from endpoint: Endpoint) async -> Result<T, Error> {
        return await Result
             .success(endpoint)
             .map(\.urlRequest)
             .asyncMap(session.data)
             .flatMap(unwrapResponse)
             .decode(T.self, decoder: decoder)
    }
    
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
