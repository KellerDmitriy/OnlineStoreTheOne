//
//  ButtonFactory.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 15.04.2024.
//

import UIKit

/// Протокол `ButtonFactory`, описывающий фабрику для создания кнопок.
protocol ButtonFactory {
    /// Создает новую кнопку.
    func createButton() -> UIButton
}

enum TypeButton {
    case greenButton
    case grayButton
}

/// Фабрика для создания заполненных кнопок с различными стилями и цветами.
final class FilledButtonFactory: ButtonFactory {
    /// Заголовок кнопки.
    let title: String
    /// Тип кнопки.
    let type: TypeButton
    /// Действие, выполняемое при нажатии на кнопку.
    let action: UIAction
    
    /// Инициализирует фабрику для создания заполненных кнопок с заданными параметрами.
    /// - Parameters:
    ///   - title: Заголовок кнопки.
    ///   - type: Тип кнопки.
    ///   - action: Действие, выполняемое при нажатии на кнопку.
    init(title: String, type: TypeButton, action: UIAction) {
        self.title = title
        self.type = type
        self.action = action
    }
    
    /// Создает новую заполненную кнопку с заданными параметрами.
    /// - Returns: Новая заполненная кнопка.
    func createButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .greenButton:
            button.backgroundColor = Colors.greenSheen
            button.setTitleColor(.white, for: .normal)
        case .grayButton:
            button.backgroundColor = Colors.lightGray
//            button.layer.cornerRadius = 12
//            button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        }
        button.titleLabel?.font = UIFont.makeTypography(.medium, size: 14)
        button.addAction(action, for: .touchUpInside)
        return button
    }
}

