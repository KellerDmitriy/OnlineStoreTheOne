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
    func createButtonWithLabel() -> UIView
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
    ///  Вью, на которую будет добавлять кнопка
    let homeView: UIView
    /// Действие кнопки
    let action: UIAction
    
    let textColor: UIColor?

    /// Инициализирует фабрику для создания заполненных кнопок с заданными параметрами.
    /// - Parameters:
    ///   - title: Текст лейбла.
    ///   - type: Тип кнопки.
    ///   - name: Имя картинки на кнопке
    ///   - homeView: Вью, на которую будет добавляться кнопка
    ///   - action: Действие кнопки

    init(title: String, type: TypeButtonWithLabel, name: String, homeView: UIView, action: UIAction, textColor: UIColor?) {
        self.title = title
        self.type = type
        self.name = name
        self.homeView = homeView
        self.action = action
        self.textColor = textColor
    }
    
    /// Создает новую заполненную кнопку с лейблом с заданными параметрами.
    /// - Returns: Новая заполненная кнопка с лейблом.
    func createButtonWithLabel() -> UIView {
        
        let button = UIButton(type: .system)
        let label = UILabel()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let image = UIImage(named: name)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        let superView = UIView()
        
        /// Настройки вью с картинкой
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        button.addAction(action, for: .touchUpInside)
        button.backgroundColor = Colors.lightGray
      
        label.text = title
        label.textColor = Colors.gray
        
        superView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .imageEditButtons:
            button.layer.cornerRadius = 5
            label.font = UIFont.makeTypography(.bold, size: 14)
            label.textColor = textColor
            
            superView.addSubview(button)
            superView.addSubview(label)
            superView.addSubview(view)
            
            NSLayoutConstraint.activate([
                superView.heightAnchor.constraint(equalToConstant: 50),
                superView.widthAnchor.constraint(equalToConstant: homeView.frame.width),

                button.heightAnchor.constraint(equalToConstant: 56),
                button.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 0),
                button.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: 0),
                
                label.topAnchor.constraint(equalTo: button.topAnchor, constant: 20),
                label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 20),
                
                view.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -40),
                view.topAnchor.constraint(equalTo: button.topAnchor, constant: 15),
            ])
            
        case .standartButton:
            button.layer.cornerRadius = 12
            label.font = UIFont.makeTypography(.bold, size: 16)
            label.textColor = Colors.gray
            
            superView.addSubview(button)
            superView.addSubview(label)
            superView.addSubview(view)
            
            NSLayoutConstraint.activate([
                superView.heightAnchor.constraint(equalToConstant: 56),
                superView.widthAnchor.constraint(equalToConstant: homeView.frame.width),

                button.heightAnchor.constraint(equalToConstant: 56),
                button.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 0),
                button.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: 0),
                
                label.topAnchor.constraint(equalTo: button.topAnchor, constant: 20),
                label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 20),
                
                view.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -40),
                view.topAnchor.constraint(equalTo: button.topAnchor, constant: 15),
            ])
        }
        
        return superView
       
    }
}







