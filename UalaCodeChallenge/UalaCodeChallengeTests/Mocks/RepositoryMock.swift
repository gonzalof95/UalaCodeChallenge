//
//  RepositoryMock.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import Combine
@testable import UalaCodeChallenge

final class CitiesRepositoryMock: CitiesRepositoryProtocol {
    // MARK: - Invocation tracking
    private(set) var invokedFetchCities = false
    private(set) var invokedFetchCitiesCount = 0

    // MARK: - Stubbing
    var stubbedResult: Result<[City], NetworkError>!

    func fetchCities<T: Decodable>() async throws -> T {
        invokedFetchCities = true
        invokedFetchCitiesCount += 1

        switch stubbedResult {
        case .success(let value):
            guard let typedValue = value as? T else {
                fatalError("Type mismatch in mock")
            }
            return typedValue

        case .failure(let error):
            throw error

        case .none:
            fatalError("stubbedResult not set")
        }
    }
}
