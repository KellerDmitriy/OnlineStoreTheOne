//
//  DIService.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 08.05.2024.
//

import Foundation

final class DependencyContainer {
    static let shared = DependencyContainer()

    private var dependencies = [String: () -> Any]()

    private init() {}

    public static func register<T>(_ dependency: @escaping () -> T) {
        shared.register(dependency, for: T.self)
    }

    public static func resolve<T>() -> T {
        return shared.resolve(T.self)
    }

    private func register<T>(_ dependency: @escaping () -> T, for type: T.Type) {
        let key = String(describing: type)
        dependencies[key] = dependency
    }

    private func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let dependency = dependencies[key] else {
            fatalError("No Dependency found for \(key). Register a dependency before resolving it.")
        }
        guard let resolvedDependency = dependency() as? T else {
            fatalError("Failed to cast dependency to \(type).")
        }
        return resolvedDependency
    }
}
