//
//  AuthService.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 24.04.2024.
//

import UIKit
import Firebase
import FirebaseFirestore

struct AuthService {
    static let shared = AuthService()
    private init() {}
    
    func logUserIn(with email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(with model: RegistrationCredentials) {
        Auth.auth().createUser(withEmail: model.email, password: model.password) { result, error in
            if let user = result?.user {
                let userData = [
                    "login": model.login,
                    "email": model.email,
                    "type": model.type,
                    "profileImageURL": ""
                ]
                Firestore.firestore().collection("users").document(user.uid).setData(userData) { error in
                    if let error {
                        print("Error saving user data: \(error)")
                    } else {
                        print("User data successfully saved!")
                    }
                }
            } else if let error {
                print("Error registering user: \(error)")
            }
        }
    }
    
}
