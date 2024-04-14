//
//  UIFont + Extension.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//

import UIKit

// MARK: - FontType
enum FontType: String {
    case bold = "Typography-Bold"
    case extraBold = "Typography-ExtraBold"
    case light = "Typography-Light"
    case medium = "Typography-Medium"
    case regular = "Typography-Regular"
    case semibold = "Typography-SemiBold"
}

// MARK: - UIFont
extension UIFont {
    static func makeTypography(_ fontType: FontType, size: CGFloat) -> UIFont {
        UIFont(name: fontType.rawValue, size: size) 
        ?? UIFont.systemFont(ofSize: size)
    }
}
