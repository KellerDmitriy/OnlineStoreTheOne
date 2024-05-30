//
//  AlertController + Extension.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 20.04.2024.
//

import UIKit

enum UIAlertFactory {
    
    static func createAlert(
        title: String,
        message: String,
        titleDefaultAction: String = "Ok",
        titleDestructiveAction: String = "Cancel",
        completion: @escaping () -> Void
    ) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: titleDefaultAction, style: .default) { _ in
            completion()
        }
        
        let cancelAction = UIAlertAction(title: titleDestructiveAction, style: .destructive)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        return alert
    }
}
