//
//  Mockable.swift
//  OnlineStoreTheOne
//
//  Created by Келлер Дмитрий on 21.07.2024.
//

import Foundation

protocol Mockable: AnyObject {
    var bundle: Bundle { get }
    func getJSON<T: Decodable>(fileName: String, type: T.Type) -> T
}


extension Mockable {
    var bundle: Bundle { Bundle(for: type(of: self)) }

    func getJSON<T: Decodable>(fileName: String, type: T.Type) -> T {
        guard let path = bundle.url(forResource: fileName, withExtension: "json") else {
            fatalError("JSON file not found: \(fileName).json")
        }
        
        do {
            let data = try Data(contentsOf: path)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            fatalError("Failed to decode JSON: \(error.localizedDescription)")
        }
    }
}
