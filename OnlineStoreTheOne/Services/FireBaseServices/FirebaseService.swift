//
//  FirebaseService.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 24.04.2024.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

protocol IFirebase {
    func isAuthenticated() -> Bool
    func signOut(completion: @escaping(Error?) -> Void)
    func logUserIn(with email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?)
    func registerUser(with model: RegistrationCredentials, completion: @escaping (Error?) -> Void)
    func changeAccountType(userId: String, type: String)
    func fetchUser(userId: String, completion: @escaping (RegistrationCredentials?) -> Void)
    func uploadUserImage(userId: String, image: UIImage)
}

final class FirebaseService: IFirebase {
    func signOut(completion: @escaping(Error?) -> Void) {
           do {
               try Auth.auth().signOut()
               completion(nil)
           } catch let error {
               completion(error)
               print(error.localizedDescription)
           }
       }
    
    func isAuthenticated() -> Bool {
        return Auth.auth().currentUser?.uid != nil
    }
    
    func logUserIn(with email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(with model: RegistrationCredentials, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: model.email, password: model.password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let user = result?.user else {
                let error = NSError(domain: "RegistrationErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown registration error"])
                completion(error)
                return
            }
            
            let userData = [
                "login": model.login,
                "email": model.email,
                "type": model.type,
                "profileImageURL": model.profileImageURL
            ]
            
            Firestore.firestore().collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
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
    
    func changeAccountType(userId: String, type: String) {
           let ref = Firestore.firestore().collection("users").document(userId)
           
           ref.updateData(["type": type]) { error in
               if let error = error {
                   print("Error updating user type: \(error)")
               }
           }
       }
}
