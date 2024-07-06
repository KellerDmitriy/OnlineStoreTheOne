//
//  ChevronButtonFactory.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 18.04.2024.
//

import UIKit
import SnapKit

/// Протокол `ButtonWithLabelFactory`, описывающий фабрику для создания кнопок.
protocol ChevronButtonFactoryProtocol {
    /// Создает новую кнопку.
    func createButtonWithChevron() -> UIButton
}

/// Фабрика для создания заполненных кнопок с шевроном.
final class ChevronButtonFactory: ChevronButtonFactoryProtocol {
    /// Текст лейбла.
    let title: String
    /// Название картинки
    let chevron: String
    /// Действие кнопки
    let action: UIAction
    /// Цвет текста
    let textColor: UIColor?
    
    /// Инициализирует фабрику для создания заполненных кнопок с заданными параметрами.
    /// - Parameters:
    ///   - title: Текст лейбла.
    ///   - chevron: Имя картинки на кнопке.
    ///   - action: Действие кнопки.
    ///   - textColor: Цвет текста.
    init(title: String, chevron: String, action: UIAction, textColor: UIColor?) {
        self.title = title
        self.chevron = chevron
        self.action = action
        self.textColor = textColor
    }
    
    /// Создает новую заполненную кнопку с текстом слева и выбранным шевроном справа.
    func createButtonWithChevron() -> UIButton {
        
        let button = UIButton(type: .system)
        button.addAction(action, for: .touchUpInside)
        button.backgroundColor = Colors.lightGray
        button.layer.cornerRadius = 8
        button.tintColor = textColor
        
        let titleLabel = LabelFactory(
            text: title,
            font: .semiBold,
            color: textColor,
            size: 16,
            alignment: .left
        )
            .createLabel()
        
        let chevronImageView = UIImageView()
        chevronImageView.image = UIImage(systemName: chevron)
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.tintColor = textColor
        
        button.addSubview(titleLabel)
        button.addSubview(chevronImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        return button
    }
}







