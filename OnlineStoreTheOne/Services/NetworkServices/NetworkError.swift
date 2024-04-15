//
//  NetworkError.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 15.04.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case transportError(Error)
    case serverError(statusCode: Int, description: String)
    case noData
    case decodingError(Error)
    case invalidURL
    case unknown(Error)
}
