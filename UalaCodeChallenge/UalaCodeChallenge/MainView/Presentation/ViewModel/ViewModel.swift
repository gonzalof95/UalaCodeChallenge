//
//  ViewModel.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import Foundation
import Combine

final class CitiesViewModel: ObservableObject {
    @Published private(set) var cities: [City] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published private var favoriteCityIDs: Set<Int> = []
    @Published var showFavoritesOnly: Bool = false
    private let service: CitiesServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(service: CitiesServiceProtocol) {
        self.service = service
        loadFavorites()
    }

    var visibleCities: [City] {
        cities
            .filter { city in
                (searchText.isEmpty ||
                 city.name.localizedCaseInsensitiveContains(searchText) ||
                 city.country.localizedCaseInsensitiveContains(searchText))
                &&
                (!showFavoritesOnly || isFavorite(city))
            }
            .sorted { $0.name == $1.name ? $0.country < $1.country : $0.name < $1.name }
    }

    func isFavorite(_ city: City) -> Bool {
        favoriteCityIDs.contains(city.id)
    }

    func toggleFavorite(_ city: City) {
        if favoriteCityIDs.contains(city.id) {
            favoriteCityIDs.remove(city.id)
        } else {
            favoriteCityIDs.insert(city.id)
        }
        saveFavorites()
    }

    func loadCities() async {
        isLoading = true
        errorMessage = nil
        do {
            cities = try await service.fetchCities()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - Favorites persistence
    private func loadFavorites() {
        if let saved = UserDefaults.standard.array(forKey: "favoriteCities") as? [Int] {
            favoriteCityIDs = Set(saved)
        }
    }

    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoriteCityIDs), forKey: "favoriteCities")
    }
}
