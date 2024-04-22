//
//  UIView + Extension.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 18.04.2024.
//

import UIKit

extension UIView {
    /// Добавляет нижнюю границу(полоску) к представлению.
    func addBottomBorder() {
        let height: CGFloat = 0.3
        let separator = UIView()
        separator.backgroundColor = Colors.gray.withAlphaComponent(0.3)
        separator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        separator.frame = CGRect(
            x: 0,
            y: frame.height - height,
            width: frame.width,
            height: height
        )
        addSubview(separator)
    }
    /// Добавляет анимацию к кастомной кнопке.
    func makeSystem(_ button: UIButton) {
        button.addTarget(
            self,
            action: #selector(handleIn),
            for: [.touchDown, .touchDragInside]
            )
        button.addTarget(
            self,
            action: #selector(handleOut),
            for: [.touchDragOutside, .touchUpInside, .touchUpOutside, .touchCancel]
        )
    }
    
    @objc func handleIn() {
        UIView.animate(withDuration: 0.15) { self.alpha = 0.55 }
    }
    
    @objc func handleOut() {
        UIView.animate(withDuration: 0.15) { self.alpha = 1 }
    }
}
