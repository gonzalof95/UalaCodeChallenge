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
    var stubbedResult: Result<Any, NetworkError>!

    func fetchCities<T: Decodable>() -> AnyPublisher<T, NetworkError> {
        invokedFetchCities = true
        invokedFetchCitiesCount += 1

        switch stubbedResult {
        case .success(let value):
            return Just(value as! T)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()

        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()

        case .none:
            fatalError("stubbedResult not set")
        }
    }
}

