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
    @Published var visibleCities: [City] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = "" {
        didSet { filterCitiesInBackground() }
    }
    @Published private var favoriteCityIDs: Set<Int> = []
    @Published var showFavoritesOnly: Bool = false {
        didSet { filterCitiesInBackground() }
    }

    private let service: CitiesServiceProtocol
    private let storage: FavoritesStorage
    private var filterTask: Task<Void, Never>?
    private var hasLoadedCities = false

    init(service: CitiesServiceProtocol, storage: FavoritesStorage = UserDefaultsFavoritesStorage()) {
        self.service = service
        self.storage = storage
        loadFavorites()
    }

    func loadCities() async {
        guard !hasLoadedCities else {
            filterCitiesInBackground()
            return
        }

        isLoading = true
        errorMessage = nil
        do {
            cities = try await service.fetchCities()
            hasLoadedCities = true
            filterCitiesInBackground()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

// MARK: Filtering for search bar
private extension CitiesViewModel {
    func filterCitiesInBackground() {
        filterTask?.cancel()

        let currentSearch = searchText
        let currentFavoritesOnly = showFavoritesOnly
        let allCities = cities
        let favoriteIDs = favoriteCityIDs

        filterTask = Task.detached(priority: .userInitiated) {
            let filtered = allCities
                .filter { city in
                    (currentSearch.isEmpty ||
                     city.name.localizedCaseInsensitiveContains(currentSearch) ||
                     city.country.localizedCaseInsensitiveContains(currentSearch))
                    && (!currentFavoritesOnly || favoriteIDs.contains(city.id))
                }
                .sorted { $0.name == $1.name ? $0.country < $1.country : $0.name < $1.name }

            await MainActor.run {
                self.visibleCities = filtered
            }
        }
    }
}

// MARK: Handle favorites
extension CitiesViewModel {
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
        filterCitiesInBackground()
    }
}

// MARK: Handle Persistence
private extension CitiesViewModel {
    func loadFavorites() {
        favoriteCityIDs = Set(storage.loadFavoriteIDs())
    }

    func saveFavorites() {
        storage.saveFavoriteIDs(Array(favoriteCityIDs))
    }
}
