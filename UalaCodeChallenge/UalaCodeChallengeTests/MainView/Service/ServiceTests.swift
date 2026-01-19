//
//  ServiceTests.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import XCTest
@testable import UalaCodeChallenge

final class CitiesServiceTests: XCTestCase {
    private var service: CitiesService!
    private var repository: CitiesRepositoryMock!

    override func setUp() {
        super.setUp()
        repository = CitiesRepositoryMock()
        service = CitiesService(repository: repository)
    }

    override func tearDown() {
        service = nil
        repository = nil
        super.tearDown()
    }

    @MainActor
    func testFetchCitiesSuccess() async throws {
        // GIVEN
        let expectedCities = [
            City(id: 1, name: "Hurzuf", country: "UA", coord: Coordinate(lon: 34.28, lat: 44.54))
        ]
        repository.stubbedResult = .success(expectedCities)

        // WHEN
        let cities = try await service.fetchCities()

        // THEN
        XCTAssertEqual(cities.count, 1)
        XCTAssertEqual(cities.first?.name, "Hurzuf")
        XCTAssertTrue(repository.invokedFetchCities)
        XCTAssertEqual(repository.invokedFetchCitiesCount, 1)
    }

    func testFetchCitiesFailure() async {
        // GIVEN
        repository.stubbedResult = .failure(.invalidResponse)

        // WHEN / THEN
        do {
            let _: [City] = try await service.fetchCities()
            XCTFail("Expected failure")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        XCTAssertTrue(repository.invokedFetchCities)
        XCTAssertEqual(repository.invokedFetchCitiesCount, 1)
    }
}
