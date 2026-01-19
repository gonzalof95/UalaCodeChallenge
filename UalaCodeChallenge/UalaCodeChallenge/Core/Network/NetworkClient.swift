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
    func request<T: Decodable>(_ url: URL) async throws -> T
}

final class URLSessionNetworkClient: NetworkClient {
    private let session: URLSession
    private let logger: Logger
    
    init(session: URLSession = .shared, logger: Logger = ConsoleLogger()) {
        self.session = session
        self.logger = logger
    }

    func request<T: Decodable>(_ url: URL) async throws -> T {
        logger.log("Starting request: \(url.absoluteString)")

        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                logger.error("Invalid response")
                throw NetworkError.invalidResponse
            }

            logger.log("Received response: \(httpResponse.statusCode)")

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                logger.error("Decoding failed: \(error)")
                throw NetworkError.decodingFailed(error)
            }

        } catch let error as URLError {
            logger.error("Request failed: \(error)")
            throw NetworkError.requestFailed(error)
        } catch {
            logger.error("Unknown error: \(error)")
            throw NetworkError.unknown
        }
    }
}
