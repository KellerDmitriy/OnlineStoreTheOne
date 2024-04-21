//
//  WishListViewModel.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 16.04.2024.
//

import Foundation
import Combine
import RealmSwift

final class WishListViewModel {
    //MARK:  Properties
    let networkService = NetworkService.shared
    let storageService = RealmStorageService.shared
    
    @Published var wishLists: Results<WishListModel>!
    
    var filteredWishLists: Results<WishListModel>? 
    
    var subscription: Set<AnyCancellable> = []
    
    //MARK: - Init
    init() {
        wishLists = storageService.realm.objects(WishListModel.self)
    }
    
    
    //MARK: - Methods
    
    func removeWishList(at id: Int) {
        storageService.removeFromWishList(id)
    }
    
}
