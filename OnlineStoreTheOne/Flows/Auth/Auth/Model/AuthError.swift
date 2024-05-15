//
//  AuthError.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 15.05.2024.
//

import Foundation

enum LoginError: Error {
    case invalidCredentials
    case networkError
}

enum RegistrationError: Error {
    case invalidData
}
