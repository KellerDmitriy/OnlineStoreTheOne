//
//  UIFont + Extension.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//

import UIKit

// MARK: - FontType
enum FontType: String {
    case thin = "Inter-Thin"
    case extraLight = "Inter-ExtraLight"
    case light = "Inter-Light"
    case regular = "Inter-Regular"
    case medium = "Inter-Medium"
    case semiBold = "Inter-SemiBold"
    case bold = "Inter-Bold"
    case extraBold = "Inter-ExtraBold"
    case black = "Inter-Black"
}

// MARK: - UIFont
extension UIFont {
    static func makeTypography(_ fontType: FontType, size: CGFloat) -> UIFont {
        UIFont(name: fontType.rawValue, size: size) 
        ?? UIFont.systemFont(ofSize: size)
    }
}
