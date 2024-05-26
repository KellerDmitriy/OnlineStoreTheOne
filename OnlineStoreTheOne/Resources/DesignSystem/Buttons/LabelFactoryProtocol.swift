//
//  LabelFactory.swift
//  OnlineStoreTheOne
//
//  Created by Дарья Большакова on 17.04.2024.
//

import UIKit

/// Протокол `LabelFactory`, описывающий фабрику для создания лэйблов.
protocol LabelFactoryProtocol {
    /// Создает новый лэйбл.
    func createLabel() -> UILabel
}

/// Фабрика для создания лэйблов с различными шрифтами и размерами.
final class LabelFactory: LabelFactoryProtocol {
    /// Текст лэйбла.
    let text: String
    /// Шрифт текста.
    let font: FontType
    /// Цвет текста.
    let color: UIColor
    /// Размер текста.
    let size: CGFloat
    /// Выравнивание
    let alignment: NSTextAlignment
    
    /// Инициализирует фабрику для создания лэйбла с заданными параметрами.
    /// - Parameters:
    ///   - text: Текст лэйбла.
    ///   - font: Шрифт текста.
    ///   - color: Цвет текста.
    ///   - size: Размер текста.
    ///   - alignment: Выравнивание текста. Значение по умолчанию - `.center`.
    init(text: String, font: FontType, color: UIColor? = nil, size: CGFloat, alignment: NSTextAlignment = .center) {
        self.text = text
        self.font = font
        self.color = color ?? Colors.gray
        self.size = size
        self.alignment = alignment
    }
    
    /// Создает новый лейбл с заданными параметрами.
    /// - Returns: Новый лэйбл.
    func createLabel() -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.makeTypography(font, size: size)
        label.textColor = color
        label.textAlignment = alignment
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
