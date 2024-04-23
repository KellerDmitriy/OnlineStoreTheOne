//
//  RealmModelProtocol.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 21.04.2024.
//

import Foundation
import RealmSwift

protocol StorableItem: Object {
    var id: Int { get set }
    var title: String { get set }
    var price: Int { get set }
    var images: List<Data> { get set }
}
