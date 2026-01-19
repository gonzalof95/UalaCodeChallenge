//
//  RepositoryTests.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import XCTest
@testable import UalaCodeChallenge

@MainActor
final class CitiesRepositoryTests: XCTestCase {
    private var repository: CitiesRepository!
    private var networkClient: NetworkClientMock!

    // MARK: - Setup / Teardown
    override func setUp() {
        super.setUp()
        networkClient = NetworkClientMock()
    }

    override func tearDown() {
        repository = nil
        networkClient = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testFetchCitiesSuccess() async throws {
        // GIVEN
        let json = """
        [{
            "country": "UA",
            "name": "Hurzuf",
            "_id": 707860,
            "coord": { "lon": 34.283333, "lat": 44.549999 }
        }]
        """.data(using: .utf8)!

        networkClient.stubbedResult = .success(json)
        let url = URL(string: "https://test.com")!
        repository = CitiesRepository(client: networkClient, url: url)

        // WHEN
        let cities = try await repository.fetchCities() as [City]

        // THEN
        XCTAssertEqual(cities.count, 1)

        let city = cities.first
        XCTAssertEqual(city?.name, "Hurzuf")
        XCTAssertEqual(city?.country, "UA")
        XCTAssertEqual(city?.id, 707860)

        XCTAssertTrue(networkClient.invokedRequest)
        XCTAssertEqual(networkClient.invokedRequestURL, url)
    }

    func testFetchCitiesFailurePropagatesError() async {
        // GIVEN
        let expectedError = NetworkError.invalidResponse
        networkClient.stubbedResult = .failure(expectedError)
        let url = URL(string: "https://test.com")!
        repository = CitiesRepository(client: networkClient, url: url)

        // WHEN / THEN
        do {
            _ = try await repository.fetchCities()
            XCTFail("Expected fetchCities() to throw")
        } catch let error as NetworkError {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }

        XCTAssertTrue(networkClient.invokedRequest)
        XCTAssertEqual(networkClient.invokedRequestURL, url)
    }
}

