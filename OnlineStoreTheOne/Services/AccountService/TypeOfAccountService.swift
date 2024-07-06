//
//  TypeOfAccountService.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 21.05.2024.
//

import Foundation
import FirebaseAuth

protocol AccountServiceProtocol {
    func updateAccount(type: String)
}

final class TypeOfAccountService: AccountServiceProtocol {
   
    
    func updateAccount(type: String) {
        if let user = Auth.auth().currentUser {
            let authService: IFirebase = DIService.resolve(forKey: .authService) ?? FirebaseService()
            
            authService.changeAccountType(userId: user.uid, type: type)
        }
    }
    
}
