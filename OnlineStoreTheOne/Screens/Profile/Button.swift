//
//  Button.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 15.04.2024.
//

import UIKit

func createButton(action: UIAction) -> UIButton {
    let button = UIButton(primaryAction: action)
    button.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 20)
    button.layer.cornerRadius = 12
    button.backgroundColor = Colors.gray
    button.translatesAutoresizingMaskIntoConstraints = false
    button.heightAnchor.constraint(equalToConstant: 55).isActive = true
    return button
    
}

