//
//  Service.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import Foundation
import Combine

protocol CitiesServiceProtocol {
    func fetchCities<T: Decodable>() -> AnyPublisher<T, NetworkError>
}

final class CitiesService: CitiesServiceProtocol {
    private let repository: CitiesRepositoryProtocol

    init(repository: CitiesRepositoryProtocol) {
        self.repository = repository
    }

    func fetchCities<T: Decodable>() -> AnyPublisher<T, NetworkError> {
        repository.fetchCities()
    }
}
