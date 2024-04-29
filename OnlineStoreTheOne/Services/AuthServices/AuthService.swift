//
//  AuthService.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 24.04.2024.
//

import UIKit
import Firebase
import FirebaseStorage

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
                    "profileImageURL": model.profileImageURL
                ]
                Firestore.firestore().collection("users").document(user.uid).setData(userData) { error in
                    if let error {
                        print("Error saving user data: \(error)")
                    }
                }
            } else if let error {
                print("Error registering user: \(error)")
            }
        }
    }
    
    func uploadUserImage(userId: String, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let storageRef = Storage.storage().reference().child("profileImage/\(userId).jpg")
        
        storageRef.putData(imageData, metadata: nil) { (matedata, error) in
            if let error {
                print("Error uploading image: \(error)")
                return
            }
            
            storageRef.downloadURL { url, error in
                if let downloadURL = url {
                    Firestore.firestore().collection("users").document(userId).updateData(["profileImageURL": downloadURL.absoluteString]) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func fetchUser(userId: String, completion: @escaping (RegistrationCredentials?) -> Void) {
        Firestore.firestore().collection("users").document(userId).getDocument {
            document,
            error in
            if let document,
               document.exists {
                let credentials = RegistrationCredentials(
                    login: document.data()?["login"] as? String ?? "",
                    email: document.data()?["email"] as? String ?? "",
                    password: "",
                    type: document.data()?["type"] as? String ?? "",
                    profileImageURL: document.data()?["profileImageURL"] as? String ?? ""
                )
                completion(credentials)
            } else {
                print("Document does not exist or error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }
}
