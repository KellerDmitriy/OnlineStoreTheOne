//
//  HomeViewController + Extension.swift
//  OnlineStoreTheOne
//
//  Created by Иван Семенов on 23.04.2024.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension HomeViewController: MainViewModelDelegate {
    func dataUpdated() {
        ///обновляем интерфейс после получения новых данных
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
