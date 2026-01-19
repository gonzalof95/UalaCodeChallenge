//
//  NetworkClientMock.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import Foundation
@testable import UalaCodeChallenge

final class NetworkClientMock: NetworkClient {
    var stubbedResult: Result<Data, NetworkError>!
    private(set) var invokedRequest = false
    private(set) var invokedRequestURL: URL?

    func request<T: Decodable>(_ url: URL) async throws -> T {
        invokedRequest = true
        invokedRequestURL = url

        switch stubbedResult {
        case .success(let data):
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                throw NetworkError.decodingFailed(error)
            }

        case .failure(let error):
            throw error

        case .none:
            fatalError("stubbedResult not set")
        }
    }
}
