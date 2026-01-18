//
//  Repository.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import Combine
import Foundation

protocol CitiesRepositoryProtocol {
    func fetchCities<T: Decodable>() -> AnyPublisher<T, NetworkError>
}

final class CitiesRepository: CitiesRepositoryProtocol {
    private let client: NetworkClient
    private let url: URL

    init(client: NetworkClient, url: URL) {
        self.client = client
        self.url = url
    }

    func fetchCities<T: Decodable>() -> AnyPublisher<T, NetworkError> {
        client.request(url)
    }
}
