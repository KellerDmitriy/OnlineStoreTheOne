//
//  Label.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 15.04.2024.
//

import UIKit

func createLabel(size: CGFloat, font: String, text: String, color: UIColor) -> UILabel {
    
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints  = false
    label.text = text
    label.font = UIFont(name: font, size: size)
    label.textColor = color
    
    return label
}
