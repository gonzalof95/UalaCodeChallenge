//
//  ServiceTests.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import XCTest
import Combine
@testable import UalaCodeChallenge

final class CitiesServiceTests: XCTestCase {
    private var service: CitiesService!
    private var repository: CitiesRepositoryMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        repository = CitiesRepositoryMock()
        service = CitiesService(repository: repository)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        service = nil
        repository = nil
        super.tearDown()
    }

    func testFetchCitiesSuccess() {
        // GIVEN
        let expectedCities = [
            City(
                id: 1,
                name: "Hurzuf",
                country: "UA",
                coord: Coordinate(lon: 34.28, lat: 44.54)
            )
        ]

        repository.stubbedResult = .success(expectedCities)

        let expectation = expectation(description: "Fetch cities succeeds")

        // WHEN
        service.fetchCities()
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail("Unexpected error: \(error)")
                }
            } receiveValue: { (cities: [City]) in
                // THEN
                XCTAssertEqual(cities.count, 1)
                XCTAssertEqual(cities.first?.name, "Hurzuf")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)

        XCTAssertTrue(repository.invokedFetchCities)
        XCTAssertEqual(repository.invokedFetchCitiesCount, 1)
    }

    func testFetchCitiesFailure() {
        // GIVEN
        repository.stubbedResult = .failure(.invalidResponse)

        let expectation = expectation(description: "Fetch cities fails")

        // WHEN
        service.fetchCities()
            .sink { completion in
                // THEN
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, .invalidResponse)
                    expectation.fulfill()
                }
            } receiveValue: { (_: [City]) in
                XCTFail("Should not emit value on failure")
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)

        XCTAssertTrue(repository.invokedFetchCities)
        XCTAssertEqual(repository.invokedFetchCitiesCount, 1)
    }
}

