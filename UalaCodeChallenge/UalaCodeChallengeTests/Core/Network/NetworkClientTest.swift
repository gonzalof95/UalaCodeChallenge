//
//  NetworkClientTest.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import XCTest
@testable import UalaCodeChallenge

final class NetworkClientTests: XCTestCase {
    private var mock: NetworkClientMock!
    private let testURL = URL(string: "https://test.com")!

    // MARK: - Setup / Teardown
    override func setUp() {
        super.setUp()
        mock = NetworkClientMock()
    }

    override func tearDown() {
        mock = nil
        super.tearDown()
    }

    // MARK: - Tests
    @MainActor
    func testNetworkClientSuccess() async throws {
        // Given
        let json = """
        {
            "country": "UA",
            "name": "Hurzuf",
            "_id": 707860,
            "coord": { "lon": 34.283333, "lat": 44.549999 }
        }
        """.data(using: .utf8)!

        mock.stubbedResult = .success(json)

        // When
        let city: City = try await mock.request(testURL)

        // Then
        XCTAssertEqual(city.name, "Hurzuf")
        XCTAssertEqual(city.country, "UA")
        XCTAssertEqual(city.id, 707860)

        assertRequestInvoked()
    }

    func testNetworkClientFailsWithInvalidResponse() async {
        // Given
        mock.stubbedResult = .failure(.invalidResponse)

        // When / Then
        do {
            let _: City = try await mock.request(testURL)
            XCTFail("Expected invalidResponse error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        assertRequestInvoked()
    }

    func testNetworkClientFailsWithMalformedData() async {
        // Given
        let malformedJSON = """
        {
            "country": "UA",
            "name": "Hurzuf",
            "_id": "NOT_AN_INT",
            "coord": { "lon": 34.283333, "lat": 44.549999 }
        }
        """.data(using: .utf8)!

        mock.stubbedResult = .success(malformedJSON)

        // When / Then
        do {
            let _: City = try await mock.request(testURL)
            XCTFail("Expected decodingFailed error")
        } catch let error as NetworkError {
            if case .decodingFailed = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Unexpected NetworkError: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        assertRequestInvoked()
    }

    func testNetworkClientFailsWithNoInternet() async {
        // Given
        let urlError = URLError(.notConnectedToInternet)
        mock.stubbedResult = .failure(.requestFailed(urlError))

        // When / Then
        do {
            let _: City = try await mock.request(testURL)
            XCTFail("Expected no internet error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .requestFailed(urlError))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        assertRequestInvoked()
    }
    
    private func assertRequestInvoked(url: String = "https://test.com", count: Int = 1) {
        XCTAssertTrue(mock.invokedRequest)
        XCTAssertEqual(mock.invokedRequestURL?.absoluteString, url)
    }
}
