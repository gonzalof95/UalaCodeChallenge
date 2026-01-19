//
//  UalaCodeChallengeUITests.swift
//  UalaCodeChallengeUITests
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import XCTest

final class UalaCodeChallengeUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testCitiesListIsShownOnLaunch() {
        let app = XCUIApplication()
        app.launch()

        let list = app.scrollViews["cities_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))
    }
    
    @MainActor
    func testTappingCityShowsMap() {
        let app = XCUIApplication()
        app.launch()

        // Wait for list
        let list = app.scrollViews["cities_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))

        // Tap first city row
        let firstCity = app.buttons.matching(NSPredicate(
            format: "identifier BEGINSWITH %@", "city_row_"
        )).firstMatch

        XCTAssertTrue(firstCity.waitForExistence(timeout: 5))
        firstCity.tap()

        // Assert map is shown
        let map = app.otherElements["city_map"]
        XCTAssertTrue(map.waitForExistence(timeout: 5))
    }
    
    @MainActor
    func testSearchFiltersCities() {
        let app = XCUIApplication()
        app.launch()

        let list = app.scrollViews["cities_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))

        let searchBar = app.textFields["search_bar"]
        XCTAssertTrue(searchBar.waitForExistence(timeout: 5))

        // Count rows before search
        let allCities = app.buttons.matching(NSPredicate(
            format: "identifier BEGINSWITH %@", "city_row_"
        ))
        let initialCount = allCities.count
        XCTAssertGreaterThan(initialCount, 0)

        // Type something
        searchBar.tap()
        searchBar.typeText("London") // e.g. "London"

        // Let SwiftUI settle
        sleep(1)

        let filteredCount = allCities.count
        XCTAssertLessThan(filteredCount, initialCount)
    }
    
    @MainActor
    func testTogglingFavorite() {
        let app = XCUIApplication()
        app.launch()

        // Wait for list
        let list = app.scrollViews["cities_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))

        // Check favorite button existance
        let favoriteButton = app.descendants(matching: .button)
            .matching(NSPredicate(format: "identifier BEGINSWITH %@", "favorite_button_"))
            .firstMatch

        // Check tap works
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 5))
        favoriteButton.tap()

        XCTAssertEqual(favoriteButton.value as? String, "favorited")
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
