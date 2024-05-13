//
//  ProfileViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 19.04.2024.
//

import Foundation

final class ProfileViewModel {
    //MARK:  Properties
    var storageService: StorageServiceProtocol
    
    //MARK: - Init
    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }
}
