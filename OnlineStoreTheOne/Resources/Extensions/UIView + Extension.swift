//
//  UIView + Extension.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 18.04.2024.
//

import UIKit

extension UIView {
    /// Добавляет тень к представлению.
    func makeCellShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
    
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
//MARK: - Shimmering
extension UIView {
    /// Добавляет эффект мерцания
    public var isShimmering: Bool {
        set {
            if newValue {
                startShimmering()
            } else {
                stopShimmering()
            }
        }
        
        get {
            return layer.mask?.animation(forKey: shimmerAnimationKey) != nil
        }
    }
    
    private var shimmerAnimationKey: String {
        return "shimmer"
    }
    
    private func startShimmering() {
        let white = UIColor.white.cgColor
        let alpha = UIColor.white.withAlphaComponent(0.75).cgColor
        let width = bounds.width
        let height = bounds.height
        
        let gradient = CAGradientLayer()
        gradient.colors = [alpha, white, alpha]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.4)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.6)
        gradient.locations = [0.4, 0.5, 0.6]
        gradient.frame = CGRect(x: -width, y: 0, width: width*3, height: height)
        layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.25
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: shimmerAnimationKey)
    }
    ///  c задержкой и повтором
    public func startShimmering(duration: TimeInterval, repeatCount: Float = 1) {
            let white = UIColor.white.cgColor
            let alpha = UIColor.white.withAlphaComponent(0.75).cgColor
            let width = bounds.width
            let height = bounds.height
            
            let gradient = CAGradientLayer()
            gradient.colors = [alpha, white, alpha]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.4)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.6)
            gradient.locations = [0.4, 0.5, 0.6]
            gradient.frame = CGRect(x: -width, y: 0, width: width*3, height: height)
            layer.mask = gradient
            
            let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
            animation.fromValue = [0.0, 0.1, 0.2]
            animation.toValue = [0.8, 0.9, 1.0]
            animation.duration = duration / Double(repeatCount)
            animation.repeatCount = repeatCount
            gradient.add(animation, forKey: shimmerAnimationKey)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.stopShimmering()
            }
        }
    
    private func stopShimmering() {
        layer.mask = nil
    }
}

