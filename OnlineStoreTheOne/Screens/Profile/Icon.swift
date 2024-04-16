//
//  Icon.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 15.04.2024.
//

import UIKit

func createIcon(name: String) -> UIView {
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    let image = UIImage(named: name)
    imageView.image = image
    imageView.contentMode = .scaleAspectFit
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
    view.addSubview(imageView)
    
    return view
}
