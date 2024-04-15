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

/// Конкретная реализация `ButtonFactory` для создания заполненных кнопок.
final class FilledButtonFactory: ButtonFactory {
    /// Заголовок кнопки.
    let title: String
    /// Цвет кнопки.
    let color: UIColor
    /// Действие, выполняемое при нажатии на кнопку.
    let action: UIAction
    
    /// Инициализатор для создания фабрики заполненных кнопок.
    /// - Parameters:
    ///   - title: Заголовок кнопки.
    ///   - color: Цвет кнопки.
    ///   - action: Действие, выполняемое при нажатии на кнопку.
    init(title: String, color: UIColor, action: UIAction) {
        self.title = title
        self.color = color
        self.action = action
    }
    
    /// Создает новую заполненную кнопку с заданными параметрами.
    /// - Returns: Новая заполненная кнопка.
    func createButton() -> UIButton {
        var attributes = AttributeContainer()
        attributes.font = UIFont.makeTypography(.medium, size: 14)
        
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = color
        buttonConfiguration.attributedTitle = AttributedString(title, attributes: attributes)
        
        let button = UIButton(configuration: buttonConfiguration, primaryAction: action)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
