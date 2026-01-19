//
//  ViewModel.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import Foundation
import Combine

@MainActor
final class CitiesViewModel: ObservableObject {
    @Published private(set) var cities: [City] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published private var favoriteCityIDs: Set<Int> = []
    private let service: CitiesServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(service: CitiesServiceProtocol) {
        self.service = service
    }

    // MARK: - Derived data (for the View)
    var visibleCities: [City] {
        cities
            .filter { city in
                searchText.isEmpty ||
                city.name.localizedCaseInsensitiveContains(searchText) ||
                city.country.localizedCaseInsensitiveContains(searchText)
            }
            .sorted {
                if $0.name == $1.name {
                    return $0.country < $1.country
                }
                return $0.name < $1.name
            }
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
    }

    func loadCities() {
        isLoading = true
        errorMessage = nil

        service.fetchCities()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] (cities: [City]) in
                self?.cities = cities
            }
            .store(in: &cancellables)
    }
}
