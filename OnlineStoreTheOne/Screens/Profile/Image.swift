//
//  Image.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 15.04.2024.
//

import UIKit

func CreateImage(name: String) -> UIImageView {
    
    let image = UIImageView()
    image.image = UIImage(named: name)
    image.contentMode = .scaleToFill
    image.translatesAutoresizingMaskIntoConstraints = false
//    image.heightAnchor.constraint(equalToConstant: view.frame.height/10).isActive = true
//    image.widthAnchor.constraint(equalToConstant: view.frame.height/10).isActive = true
    image.layer.borderWidth = 0.5
    image.layer.masksToBounds = false
//    image.layer.cornerRadius = view.frame.height/20
    image.clipsToBounds = true    
    return image
}
