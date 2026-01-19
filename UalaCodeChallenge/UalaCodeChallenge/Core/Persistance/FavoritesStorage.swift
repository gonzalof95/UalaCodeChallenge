//
//  FavoritesStorage.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 19/01/2026.
//

import Foundation

protocol FavoritesStorage {
    func loadFavoriteIDs() -> [Int]
    func saveFavoriteIDs(_ ids: [Int])
}

struct UserDefaultsFavoritesStorage: FavoritesStorage {
    private let key = "favoriteCities"

    func loadFavoriteIDs() -> [Int] {
        UserDefaults.standard.array(forKey: key) as? [Int] ?? []
    }

    func saveFavoriteIDs(_ ids: [Int]) {
        UserDefaults.standard.set(ids, forKey: key)
    }
}
