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
        return isEmailValid 
        && isPasswordValid
        && isConfirmPasswordValid
        && isLoginValid
        && isTypeValid
        && passwordsMatch
    }

    private var isEmailValid: Bool {
        guard let email = email else {
            return false
        }
        
        let isValid = !email.isEmpty && email.isValidEmail
        return isValid
    }

    private var isPasswordValid: Bool {
        guard let password = password else {
            return false
        }
        let isValid = !password.isEmpty
        return isValid
    }

    private var isConfirmPasswordValid: Bool {
        guard let confirmPassword = confirmPassword else {
            return false
        }
        let isValid = !confirmPassword.isEmpty
        return isValid
    }

    private var isLoginValid: Bool {
        guard let login = login else {
            return false
        }
        let isValid = !login.isEmpty
        return isValid
    }

    private var isTypeValid: Bool {
        guard let type = type else {
            return false
        }
        let isValid = !type.isEmpty
        return isValid
    }

    private var passwordsMatch: Bool {
        let isMatch = password == confirmPassword
        return isMatch
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


