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
        var attributes = AttributeContainer()
        attributes.font = UIFont.makeTypography(.medium, size: 14)
        
        var buttonConfiguration: UIButton.Configuration
        
        switch type {
        case .greenButton:
            buttonConfiguration = UIButton.Configuration.filled()
            buttonConfiguration.baseBackgroundColor = Colors.greenSheen
            attributes.foregroundColor = .white
        case .grayButton:
            buttonConfiguration = UIButton.Configuration.filled()
            buttonConfiguration.baseBackgroundColor = Colors.lightGray
            attributes.foregroundColor = .black
        }
        
        buttonConfiguration.attributedTitle = AttributedString(title, attributes: attributes)
        
        let button = UIButton(configuration: buttonConfiguration, primaryAction: action)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
