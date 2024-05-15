//
//  LoginViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 23.04.2024.
//

import Foundation


protocol LoginViewModelProtocol {
    var email: String? { get set }
    var password: String? { get set }
    var formIsValid: Bool { get }
    
    func logUserIn(completion: @escaping (Error?) -> Void)
}

final class LoginViewModel: LoginViewModelProtocol {
    let authService: IFirebase = DIService.resolve(forKey: .authService) ?? FirebaseService()
    
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
        && password?.isEmpty == false
        && email?.isValidEmail == true
    }
    
    func logUserIn(completion: @escaping ((any Error)?) -> Void) {
        guard let email = email, let password = password else {
            completion(LoginError.invalidCredentials)
            return
        }
        
        authService.logUserIn(with: email, password: password) { result, error in
            completion(error)
        }
    }
}
