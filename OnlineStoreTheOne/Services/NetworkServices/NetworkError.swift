//
//  NetworkError.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 15.04.2024.
//

import Foundation

/// Ошибки, связанные с сетевыми запросами.
enum NetworkError: Error {
    /// Недопустимый ответ от сервера.
    case invalidResponse
    /// Ошибка транспорта при сетевом запросе.
    case transportError(Error)
    /// Ошибка сервера с указанным статус-кодом и описанием.
    case serverError(statusCode: Int, description: String)
    /// Отсутствие данных в ответе.
    case noData
    /// Ошибка декодирования данных.
    case decodingError(Error)
    /// Недопустимый URL.
    case invalidURL
    /// Неизвестная ошибка сети.
    case unknown(Error)
}

extension NetworkError {
    
    // MARK: - Initialization
    
    /// Инициализация ошибки сети на основе переданной ошибки.
    /// - Parameter error: Ошибка, на основе которой создается объект NetworkError.
    public init(_ error: Error) {
        if let networkError = error as? NetworkError {
            self = networkError
            return
        }
        
        switch error {
        case is URLError:
            self = .invalidURL
            
        case is DecodingError:
            self = .decodingError(error)
            
        default:
            self = .unknown(error)
        }
    }
}
