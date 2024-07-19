//
//  Resources.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 30.05.2024.
//

import UIKit

enum Resources {
    
    enum Image {
        static let searchIcon = UIImage(named: "magnifyingglass")
        //        Onboarding
        static let onboarding1 = UIImage(named: "Onboarding1")
        static let onboarding2 = UIImage(named: "Onboarding2")
        static let onboarding3 = UIImage(named: "Onboarding3")
        
        static let chevronDown = UIImage(systemName: "chevron.down")
        //        TabBar
        static let home = UIImage(named: "Home")
        static let selectedHome = UIImage(named: "selectedHome")
        static let wishList = UIImage(named: "Wishlist")
        static let selectedWishlist = UIImage(named: "selectedWishlist")
        static let manager = UIImage(named: "Manager")
        static let selectedManager = UIImage(named: "selectedManager")
        static let profileTab = UIImage(named: "ProfileTab")
        static let selectedProfile = UIImage(named: "selectedProfile")
        //        Auth
        static let logo = UIImage(named: "logo")
        static let mail = UIImage(named: "mail")
        static let lock = UIImage(named: "lock")
        static let person = UIImage(named: "person")
        static let chevronForward = UIImage(systemName: "chevron.forward")
        //        Profile
        static let profileImage = UIImage(named: "ProfileImage")
        static let editIcon = UIImage(named: "EditIcon")
        static let cameraIcon = UIImage(named: "camera")
        static let folderIcon = UIImage(named: "folder")
        static let trashIcon = UIImage(named: "trash.fill")
        
    }
    
    enum Texts {
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
        static let enterName = "Enter your Name"
        static let enterEmail = "Enter your Email"
        static let enterPassword = "Enter your Password"
        static let confirmPassword = "Confirm your Password"
        static let typeOfAccount = "Type of account"
        static let alreadyHaveAccount = "Already have an account? "
        static let logIn = "Log In"
        static let completeYourAccount = "Complete your account"
        static let chevronForward = "chevron.forward"
        static let error = "Error"
        
        //        DetailsViewController
        static let addToCart = "Add to Cart"
        static let buyNow = "Buy Now"
        static let detailsProductTitle = "Details product"
        // Carts
        static let deliveryTo = "Delivery to:"
        static let moroccoAddress = "Moroco, St. 1/4"
        static let orderSummary = "Order Summary:"
        static let totals = "Totals:"
        static let hundredDollars = "100 $"
        static let selectedPaymentMethod = "Selected payment method"
        static let yourCart = "Your Cart"
        //        Profile
        static let attention = "Attention"
        static let signOutMessage = "Are you sure you want to sign out?"
        static let signOut = "Sign Out"
        static let cancel = "Cancel"
        static let userName = "DevP"
        static let userEmail = "dev@gmail.com"
        static let termsConditions = "Terms & Conditions"
        static let arrowForward = "arrow.forward.to.line.square"
        
        static let changeYourPicture = "Change your picture"
        static let takePhoto = "Take a photo"
        static let chooseFromYourFile = "Choose from your file"
        static let deletePhoto = "Delete Photo"
        
        static let errorTitle = "exit error"
        static let ok = "Ok"
        static let searchResultHeader = "Search result for "
    }
}

