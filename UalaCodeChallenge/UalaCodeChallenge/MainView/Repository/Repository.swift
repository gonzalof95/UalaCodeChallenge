//
//  Repository.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import Combine
import Foundation

protocol CitiesRepositoryProtocol {
    func fetchCities() async throws -> [City]
}

final class CitiesRepository: CitiesRepositoryProtocol {
    private let client: NetworkClient
    private let url: URL

    init(client: NetworkClient, url: URL) {
        self.client = client
        self.url = url
    }

    func fetchCities() async throws -> [City] {
        try await client.request(url)
    }
}
