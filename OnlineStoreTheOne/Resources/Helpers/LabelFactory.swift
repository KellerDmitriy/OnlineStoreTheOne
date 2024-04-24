//
//  LabelFactory.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 17.04.2024.
//

import UIKit

/// Протокол `LabelFactory`, описывающий фабрику для создания лэйблов.
protocol LabelFactory {
    /// Создает новый лэйбл.
    func createLabel() -> UILabel
}

/// Фабрика для создания лэйблов с различными шрифтами и размерами.
final class NewLabelFactory: LabelFactory {
    /// Текст лэйбла.
    let text: String
    /// Шрифт текста.
    let font: FontType
    /// Цвет текста.
    let color: UIColor
    /// Размер текста.
    let size: CGFloat
    /// Инициализирует фабрику для создания лэйбла с заданными параметрами.
    /// - Parameters:
    ///   - text: Текст лэйбла.
    ///   - font: Шрифт текста.
    ///   - size: Размер текста.
    init(text: String, font: FontType, color: UIColor? = nil, size: CGFloat) {
        self.text = text
        self.font = font
        self.color = color ?? Colors.gray
        self.size = size
    }
    
    /// Создает новый лейбл с заданными параметрами.
    /// - Returns: Новая лэйбл.
    func createLabel() -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.makeTypography(font, size: size)
        label.textColor = color
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }
    
}
