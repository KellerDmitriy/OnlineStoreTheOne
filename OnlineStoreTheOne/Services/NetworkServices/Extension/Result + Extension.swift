//
//  Result + Extension.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 15.04.2024.
//

import Foundation

public extension Result where Failure == Error {
    
    /// Creates a new result by evaluating a asynchronous throwing closure, capturing the returned value as a success, or any thrown error as a failure.
    /// - Parameter body: A asynchronous throwing closure to evaluate.
    @inlinable
    init(asyncCatch body: () async throws -> Success) async {
        do {
            let success = try await body()
            self = .success(success)
        } catch {
            self = .failure(error)
        }
    }
    
    @inlinable
    func asyncMap<T>(
        _ transform: (Success) async throws -> T
    ) async -> Result<T, Failure> {
        switch self {
        case .success(let success):
            return await Result<T, Failure> { try await transform(success) }
            
        case .failure(let failure):
            return .failure(failure)
        }
    }
    
    @inlinable
    func asyncFlatMap<T>(
        _ transform: (Success) async -> Result<T, Failure>
    ) async -> Result<T, Failure> {
        switch self {
        case .success(let success):
            return await transform(success)
            
        case .failure(let failure):
            return .failure(failure)
        }
    }
}

public extension Result where Success == Data {
    @inlinable
    func decode<T: Decodable>(_ type: T.Type, decoder: JSONDecoder) -> Result<T, Error> {
        switch self {
        case .success(let success):
            return Result<T, Error> { try decoder.decode(type.self, from: success) }
            
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
