//
//  RegistrationViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 23.04.2024.
//

import Foundation 
protocol RegistrationViewModelProtocol {
    var login: String? { get set }
    var email: String? { get set }
    var password: String? { get set }
    var confirmPassword: String? { get set }
    var type: String? { get set }
    var formIsValid: Bool { get }
    
    func registerUser(completion: @escaping (Error?) -> Void)
    func showErrorInfo(message: String, action: @escaping ()-> Void)
    func showLoginFlow()
    func coordinatorDidFinish()
}

final class RegistrationViewModel: RegistrationViewModelProtocol {
    
    let authService: IFirebase = DIService.resolve(forKey: .authService) ?? FirebaseService()
    weak var coordinator: IAuthCoordinator?
    
    var login: String?
    var email: String?
    var password: String?
    var confirmPassword: String?
    var type: String?
    
    var formIsValid: Bool {
        guard let email = email,
              let password = password,
              let confirmPassword = confirmPassword,
              let login = login,
              let type = type else {
            return false
        }
        
        return !email.isEmpty
            && !password.isEmpty
            && !confirmPassword.isEmpty
            && !login.isEmpty
            && password == confirmPassword
            && !type.isEmpty
            && email.isValidEmail
    }
    
    
    //    MARK: - Init
    init(coordinator: IAuthCoordinator ) {
        self.coordinator = coordinator
    }
    
    //    MARK: - Methods
    func registerUser(completion: @escaping (Error?) -> Void) {
        guard let login = login,
              let email = email,
              let password = password,
              let type = type else {
            completion(RegistrationError.invalidData)
            return
        }
        
        let credentials = RegistrationCredentials(
            login: login,
            email: email,
            password: password,
            type: type,
            profileImageURL: ""
        )
        
        authService.registerUser(with: credentials) { error in
            completion(error)
        }
    }
    
    //    MARK: - Route
    func showErrorInfo(message: String, action: @escaping ()->Void) {
        coordinator?.showAlertController(
            title: "Error",
            message: message,
            createAction: action)
    }
    
    func showLoginFlow() {
        coordinator?.showLoginScene()
    }
    
    func coordinatorDidFinish() {
        coordinator?.finish()
    }
}


