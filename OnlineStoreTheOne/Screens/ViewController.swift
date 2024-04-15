//
//  ViewController.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 14.04.2024.
//

import UIKit

class ViewController: UIViewController {

    let networkService = NetworkService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.yellow
        fetchProducts()
    }

    func fetchProducts() {
        Task {
            await networkService.fetchAllProducts()
        }
    }

}

