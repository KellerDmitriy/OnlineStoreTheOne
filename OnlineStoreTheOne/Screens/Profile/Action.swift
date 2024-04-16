//
//  Action.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 15.04.2024.
//

import UIKit

func action() -> UIAction {
    let action = UIAction { _ in
        print("Profile")
    }
    return action
}

var showPassword = false
func passwordAction() -> UIAction {
    let action = UIAction { _ in
        
        if showPassword {
            ProfileScreen().userPassword.text = "jjj"
            print("hello")
            showPassword = false
        } else {
            ProfileScreen().userPassword.text = "12345"
            print("hello2")
            showPassword = true
        }
    }
    return action
}
