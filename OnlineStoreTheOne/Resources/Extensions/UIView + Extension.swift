//
//  UIView + Extension.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 18.04.2024.
//

import UIKit

extension UIView {
    /// Добавляет нижнюю границу к представлению с заданной высотой.
       ///
       /// - Parameter height: Высота нижней границы.
    func addBottomBorder(height: CGFloat ) {
        let separator = UIView()
        separator.backgroundColor = Colors.gray
        separator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        separator.frame = CGRect(
            x: 0,
            y: frame.height - height,
            width: frame.width,
            height: height
        )
        addSubview(separator)
    }
}
