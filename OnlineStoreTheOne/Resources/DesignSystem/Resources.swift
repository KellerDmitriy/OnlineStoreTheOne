//
//  Resources.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 30.05.2024.
//

import UIKit

import UIKit

enum Resources {
    
    enum Image {
        static let chevronDown = UIImage(systemName: "chevron.down")
//        tabBar
        static let home = UIImage(named: "Home")
        static let selectedHome = UIImage(named: "selectedHome")
        static let wishList = UIImage(named: "Wishlist")
        static let selectedWishlist = UIImage(named: "selectedWishlist")
        static let manager = UIImage(named: "Manager")
        static let selectedManager = UIImage(named: "selectedManager")
        static let profileTab = UIImage(named: "ProfileTab")
        static let selectedProfile = UIImage(named: "selectedProfile")
//        auth
        static let logo = UIImage(named: "logo")
        static let mail = UIImage(named: "mail")
        static let lock = UIImage(named: "lock")
        
    }
    
    enum Text {
        static let deliveryAddress = "Delivery address"
        //        tabBar
        static let home = "Home"
        static let wishList = "Wish List"
        static let manager = "Manager"
        static let profile = "Profile"
        //        auth
        static let email = "Email"
        static let password = "Password"
        static let login = "Log In"
        static let dontHaveAccount = "Don't have an account? "
        static let signUp = "Sign Up"
    }
}

