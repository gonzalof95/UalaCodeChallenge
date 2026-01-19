//
//  CitiesService.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import Foundation
import Combine

protocol CitiesServiceProtocol {
    func fetchCities() async throws -> [CityModel]
}

final class CitiesService: CitiesServiceProtocol {
    private let repository: CitiesRepositoryProtocol

    init(repository: CitiesRepositoryProtocol) {
        self.repository = repository
    }

    func fetchCities() async throws -> [CityModel] {
        try await repository.fetchCities()
    }
}
