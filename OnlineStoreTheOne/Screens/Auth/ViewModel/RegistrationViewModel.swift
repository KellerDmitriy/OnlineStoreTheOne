//
//  RegistrationViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 23.04.2024.
//

import Foundation

struct RegistrationViewModel: AuthenticationProtocol {
    var login: String?
    var email: String?
    var password: String?
    var confirmPassword: String?
    var type: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
        && password?.isEmpty == false
        && confirmPassword?.isEmpty == false
        && login?.isEmpty == false
        && password == confirmPassword
        && type?.isEmpty == false
    }
}
