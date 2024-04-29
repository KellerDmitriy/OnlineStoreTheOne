//
//  StorageError.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 21.04.2024.
//

import Foundation

enum StorageError: Error {
    case noImageURLFound
    case imageConversionFailed
    case itemNotFound
    case invalidItemType
}
