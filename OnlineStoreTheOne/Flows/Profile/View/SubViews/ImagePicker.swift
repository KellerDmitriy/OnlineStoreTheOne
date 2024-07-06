//
//  ImagePicker.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 21.04.2024.
//

import UIKit

class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePickerController: UIImagePickerController?
    var completition: ((UIImage) -> ())?
    
    func showImagePicker(in vc: UIViewController, source: UIImagePickerController.SourceType, completition: ((UIImage) -> ())?) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            self.completition = completition
            imagePickerController = UIImagePickerController()
            imagePickerController?.delegate = self
            vc.present(imagePickerController!, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.completition?(image)
            picker.dismiss(animated: true)
        }
    }
}
