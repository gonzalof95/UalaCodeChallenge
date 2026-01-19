//
//  FavoritesStorageMock.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 19/01/2026.
//

import Foundation
@testable import UalaCodeChallenge

final class MockFavoritesStorage: FavoritesStorage {
    var savedIDs: [Int] = []
    var loadedIDs: [Int] = []

    func loadFavoriteIDs() -> [Int] {
        loadedIDs
    }

    func saveFavoriteIDs(_ ids: [Int]) {
        savedIDs = ids
    }
}
