//
//  Observable.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//

import Foundation

class Observable<T> {
    typealias Lisner = (T) -> Void
    var lisner: Lisner?

    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.lisner?(self.value)
            }
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(lisner: Lisner?) {
        self.lisner = lisner
    }

}
