//
//  ImagePickerController.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 21.04.2024.
//

import UIKit

class ImagePickerController: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePickerController: ImagePickerController
    
    func showImagePicker(in viewController: UIViewController) {
//        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        viewController.present(imagePickerController!, animated: true)
    }
}
