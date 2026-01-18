//
//  NetworkClientMock.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import Foundation
@preconcurrency import Combine
@testable import UalaCodeChallenge

struct TestModel: Decodable, Equatable {
    let name: String
}

final class NetworkClientMock: NetworkClient {
    // MARK: - Invocation tracking
    private(set) var invokedRequest = false
    private(set) var invokedRequestCount = 0
    private(set) var invokedRequestURL: URL?

    // MARK: - Stubbing
    var stubbedResult: Result<Data, NetworkError>!

    func request<T: Decodable>(_ url: URL) -> AnyPublisher<T, NetworkError> {
        invokedRequest = true
        invokedRequestCount += 1
        invokedRequestURL = url

        switch stubbedResult {
        case .success(let data):
            return Just(data)
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { error in
                    if let networkError = error as? NetworkError {
                        return networkError
                    } else {
                        return .decodingFailed(error)
                    }
                }
                .eraseToAnyPublisher()

        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()

        case .none:
            fatalError("stubbedResult not set")
        }
    }
}

