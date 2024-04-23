//
//  Color + Extension.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//

import UIKit

enum Colors {
    public static let greenSheen = UIColor(hex: "#67C4A7")
    public static let darkArsenic = UIColor(hex: "#393F42")
    public static let lightGray = UIColor(hex: "#F3F4F7")
    public static let gray = UIColor(hex: "#939393")
    public static let red = UIColor(hex: "#D65B5B")
    public static let yellow = UIColor(hex: "#F79008")
    public static let green = UIColor(hex: "#12B6A")
    public static let grayBackgroundAuth = UIColor(hex: "#FBFBFB")
    public static let grayBorderAuth = UIColor(hex: "#EDEDED")
    public static let grayPlaceholderAuth = UIColor(hex: "#7C7C7B")
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}



