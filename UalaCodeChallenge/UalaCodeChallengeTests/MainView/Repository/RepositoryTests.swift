//
//  RepositoryTests.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import XCTest
import Combine
@testable import UalaCodeChallenge

final class CitiesRepositoryTests: XCTestCase {
    private var repository: CitiesRepository!
    private var networkClient: NetworkClientMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        networkClient = NetworkClientMock()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        repository = nil
        networkClient = nil
        super.tearDown()
    }

    func testFetchCitiesSuccess() {
        // GIVEN
        let json = """
        {
            "country": "UA",
            "name": "Hurzuf",
            "_id": 707860,
            "coord": { "lon": 34.283333, "lat": 44.549999 }
        }
        """.data(using: .utf8)!

        networkClient.stubbedResult = .success(json)
        let url = URL(string: "https://test.com")!
        repository = CitiesRepository(client: networkClient, url: url)
        let expectation = expectation(description: "Fetch cities")

        // WHEN
        repository.fetchCities()
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail("Unexpected error: \(error)")
                }
            } receiveValue: { (city: City) in
                // THEN
                XCTAssertEqual(city.name, "Hurzuf")
                XCTAssertEqual(city.country, "UA")
                XCTAssertEqual(city.id, 707860)

                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(networkClient.invokedRequest)
        XCTAssertEqual(networkClient.invokedRequestURL, url)
    }
    
    func testFetchCitiesFailurePropagatesError() {
        // GIVEN
        let expectedError = NetworkError.invalidResponse
        networkClient.stubbedResult = .failure(expectedError)
        let url = URL(string: "https://test.com")!
        repository = CitiesRepository(client: networkClient, url: url)
        let expectation = expectation(description: "Fetch cities fails")

        // WHEN
        repository.fetchCities()
            .sink { completion in
                if case .failure(let error) = completion {
                    // THEN
                    XCTAssertEqual(error, expectedError)
                    expectation.fulfill()
                }
            } receiveValue: { (_: City) in
                XCTFail("Should not emit value on failure")
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(networkClient.invokedRequest)
    }
}
