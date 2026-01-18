//
//  NetworkClientTest.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import XCTest
import Combine
@testable import UalaCodeChallenge

final class NetworkClientTests: XCTestCase {
    private var mock: NetworkClientMock!
    private var cancellables: Set<AnyCancellable>!
    private let testURL = URL(string: "https://test.com")!

    // MARK: - Setup / Teardown
    override func setUp() {
        super.setUp()
        mock = NetworkClientMock()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        mock = nil
        super.tearDown()
    }

    // MARK: - Tests
    func testNetworkClientSuccess() {
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
        let expectation = expectation(description: "Succeeds")

        // When
        mock.request(testURL)
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail("Unexpected error: \(error)")
                }
            } receiveValue: { (model: City) in
                // Then
                XCTAssertEqual(model.name, "Hurzuf")
                XCTAssertEqual(model.country, "UA")
                XCTAssertEqual(model.id, 707860)
                
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
        assertRequestInvoked(url: "https://test.com", count: 1)
    }

    
    func testNetworkClientFailsWithInvalidResponse() {
        // Given
        mock.stubbedResult = .failure(.invalidResponse)
        let expectation = expectation(description: "Request fails with invalidResponse")

        // When
        mock.request(testURL)
            .sink { completion in
                // Then
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, .invalidResponse)
                    expectation.fulfill()
                }
            } receiveValue: { (_: City) in
                XCTFail("Should not emit value on failure")
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
        assertRequestInvoked(url: "https://test.com", count: 1)
    }
    
    func testNetworkClientFailsWithMalformedData() {
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
        let expectation = expectation(description: "Fails with decoding error")

        // When
        mock.request(testURL)
            .sink { completion in
                //Then
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, .decodingFailed(error as NSError))
                    expectation.fulfill()
                }
            } receiveValue: { (_: City) in
                XCTFail("Should not succeed")
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
        assertRequestInvoked(url: "https://test.com", count: 1)
    }

    func testNetworkClientFailsWithNoInternet() {
        // Given
        let urlError = URLError(.notConnectedToInternet)
        mock.stubbedResult = .failure(.requestFailed(urlError))
        let expectation = expectation(description: "Fails with no internet")

        // When
        mock.request(testURL)
            .sink { completion in
                if case .failure(let error) = completion {
                    // Then
                    XCTAssertEqual(error, .requestFailed(urlError))
                    expectation.fulfill()
                }
            } receiveValue: { (_: City) in
                XCTFail("Should not emit value when there is no internet")
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
        assertRequestInvoked(url: "https://test.com", count: 1)
    }
    
    private func assertRequestInvoked(url: String = "https://test.com", count: Int = 1) {
        XCTAssertTrue(mock.invokedRequest)
        XCTAssertEqual(mock.invokedRequestCount, count)
        XCTAssertEqual(mock.invokedRequestURL?.absoluteString, url)
    }
}
