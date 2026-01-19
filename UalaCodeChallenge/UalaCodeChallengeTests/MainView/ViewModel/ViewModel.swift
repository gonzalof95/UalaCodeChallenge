//
//  ViewModel.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 19/01/2026.
//

import XCTest
@testable import UalaCodeChallenge

@MainActor
final class CitiesViewModelTests: XCTestCase {
    private var service: CitiesServiceMock!
    private var viewModel: CitiesViewModel!

    override func setUp() {
        super.setUp()
        service = CitiesServiceMock()
        viewModel = CitiesViewModel(service: service)
        UserDefaults.standard.removeObject(forKey: "favoriteCities")
    }

    override func tearDown() {
        viewModel = nil
        service = nil
        super.tearDown()
    }

    func testLoadCitiesSuccess() async {
        // Given
        let cities = [
            City(id: 1, name: "Hurzuf", country: "UA", coord: Coordinate(lon: 34, lat: 44)),
            City(id: 2, name: "Sydney", country: "AU", coord: Coordinate(lon: 151, lat: -33))
        ]
        service.stubbedResult = .success(cities)

        // When
        await viewModel.loadCities()
        try? await Task.sleep(nanoseconds: 50_000_000)

        // Then
        XCTAssertEqual(viewModel.cities.count, 2)
        XCTAssertEqual(viewModel.visibleCities.map { $0.name }, ["Hurzuf", "Sydney"])
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoadCitiesFailure() async {
        // Given
        service.stubbedResult = .failure(NetworkError.invalidResponse)

        // When
        await viewModel.loadCities()

        // Then
        XCTAssertEqual(viewModel.cities.count, 0)
        XCTAssertEqual(viewModel.visibleCities.count, 0)
        XCTAssertEqual(viewModel.errorMessage, NetworkError.invalidResponse.localizedDescription)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testSearchFiltering() async {
        // Given
        let cities = [
            City(id: 1, name: "Hurzuf", country: "UA", coord: Coordinate(lon: 34, lat: 44)),
            City(id: 2, name: "Sydney", country: "AU", coord: Coordinate(lon: 151, lat: -33))
        ]
        service.stubbedResult = .success(cities)
        await viewModel.loadCities()

        // When
        viewModel.searchText = "sy"

        // Wait a tiny bit for the background filter task to complete
        try? await Task.sleep(nanoseconds: 50_000_000)

        // Then
        XCTAssertEqual(viewModel.visibleCities.map { $0.name }, ["Sydney"])
    }

    func testToggleFavoriteUpdatesVisibleCities() async {
        // Given
        let cities = [
            City(id: 1, name: "Hurzuf", country: "UA", coord: Coordinate(lon: 34, lat: 44)),
            City(id: 2, name: "Sydney", country: "AU", coord: Coordinate(lon: 151, lat: -33))
        ]
        service.stubbedResult = .success(cities)
        await viewModel.loadCities()
        viewModel.showFavoritesOnly = true

        // When
        viewModel.toggleFavorite(cities[1])
        try? await Task.sleep(nanoseconds: 50_000_000)

        // Then
        XCTAssertEqual(viewModel.visibleCities.map { $0.name }, ["Sydney"])
        XCTAssertTrue(viewModel.isFavorite(cities[1]))
        XCTAssertFalse(viewModel.isFavorite(cities[0]))
    }
}

