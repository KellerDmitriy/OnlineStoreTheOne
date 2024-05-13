//
//  DIService.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 08.05.2024.
//

import Foundation

enum DIKey {
    case networkService
    case storageService
    case authService
}

final class DIService {
    static let shared = DIService()

    private var dependencies = [DIKey: () -> Any]()

    private init() {}

    public static func register<T>(_ dependency: @escaping () -> T, forKey key: DIKey) {
        shared.register(dependency, forKey: key)
    }

    public static func resolve<T>(forKey key: DIKey) -> T? {
        return shared.resolve(forKey: key)
    }

    private func register<T>(_ dependency: @escaping () -> T, forKey key: DIKey) {
        dependencies[key] = dependency
    }

    private func resolve<T>(forKey key: DIKey) -> T? {
        guard let dependency = dependencies[key] else {
            return nil
        }
        return dependency() as? T
    }
}
