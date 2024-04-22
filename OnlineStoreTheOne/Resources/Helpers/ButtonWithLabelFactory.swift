//
//  ButtonWithLabelFactory.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 18.04.2024.
//

import UIKit

/// Протокол `ButtonWithLabelFactory`, описывающий фабрику для создания кнопок.
protocol ButtonWithLabelFactory {
    /// Создает новую кнопку.
    func createButtonWithLabel() -> (UIButton, UILabel, UIView)
}

enum TypeButtonWithLabel {
    case imageEditButtons
    case standartButton
}
/// Фабрика для создания заполненных кнопок с лейблами.
final class ButtonLabelFactory: ButtonWithLabelFactory {
    /// Текст лейбла.
    let title: String
    /// Тип кнопки.
    let type: TypeButtonWithLabel
    /// Название картинки
    let name: String
    /// Действие кнопки
    let action: UIAction
    /// Цвет текста
    let textColor: UIColor?

    /// Инициализирует фабрику для создания заполненных кнопок с заданными параметрами.
    /// - Parameters:
    ///   - title: Текст лейбла.
    ///   - type: Тип кнопки.
    ///   - name: Имя картинки на кнопке
    ///   - action: Действие кнопки
    ///   - textColor: Цвет текста
    init(title: String, type: TypeButtonWithLabel, name: String, action: UIAction, textColor: UIColor?) {
        self.title = title
        self.type = type
        self.name = name
        self.action = action
        self.textColor = textColor
    }
    
    /// Создает новую заполненную кнопку с лейблом с заданными параметрами.
    /// - Returns: Новая заполненная кнопка с лейблом.
    func createButtonWithLabel() -> (UIButton, UILabel, UIView) {
        
        let button = UIButton(type: .system)
        let label = UILabel()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let image = UIImage(named: name)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        
        /// Настройки вью с картинкой
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        button.addAction(action, for: .touchUpInside)
        button.backgroundColor = Colors.lightGray
        button.makeSystem(button)
        label.text = title
        label.textColor = Colors.gray
        
        button.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .imageEditButtons:
            button.layer.cornerRadius = 5
            label.font = UIFont.makeTypography(.bold, size: 16)
            label.textColor = textColor
            button.heightAnchor.constraint(equalToConstant: 56).isActive = true
//
        case .standartButton:
            button.layer.cornerRadius = 12
            label.font = UIFont.makeTypography(.bold, size: 16)
            label.textColor = Colors.gray
            button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        }
        
        return (button, label, view)
       
    }
}







