//
//  AlertController + Extension.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 20.04.2024.
//

import UIKit

enum UIAlertFactory {
    
    static func createAlert(title: String, message: String, completion: @escaping (String) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            guard let newValue = alert.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        return alert
    }
}
