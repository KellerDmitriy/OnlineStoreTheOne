//
//  String+Extension.swift
//  OnlineStoreTheOne
//
//  Created by Razumov Pavel on 24.04.2024.
//

import UIKit

extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}
