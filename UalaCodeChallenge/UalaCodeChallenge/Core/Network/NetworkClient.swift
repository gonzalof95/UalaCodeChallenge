//
//  NetworkClient.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import Foundation
import Combine

enum NetworkError: Error, Equatable {
    case invalidURL
    case requestFailed(URLError)
    case invalidResponse
    case decodingFailed(Error)
    case unknown

    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true

        case (.invalidResponse, .invalidResponse):
            return true

        case (.unknown, .unknown):
            return true

        case (.requestFailed(let l), .requestFailed(let r)):
            return l.code == r.code

        case (.decodingFailed, .decodingFailed):
            return true

        default:
            return false
        }
    }
}

protocol NetworkClient {
    func request<T: Decodable>(_ url: URL) -> AnyPublisher<T, NetworkError>
}

final class URLSessionNetworkClient: NetworkClient {
    private let session: URLSession
    private let logger: Logger
    
    init(session: URLSession = .shared, logger: Logger = ConsoleLogger()) {
        self.session = session
        self.logger = logger
    }
    
    func request<T: Decodable>(_ url: URL) -> AnyPublisher<T, NetworkError> {
        logger.log("Starting request: \(url.absoluteString)")
        
        return session.dataTaskPublisher(for: url)
            .mapError { NetworkError.requestFailed($0) }
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode else {
                    throw NetworkError.invalidResponse
                }
                
                self.logger.log("Received response: \(response.statusCode)")
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if let networkError = error as? NetworkError {
                    self.logger.error("Network error: \(networkError)")
                    return networkError
                } else {
                    self.logger.error("Decoding error: \(error)")
                    return .decodingFailed(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
