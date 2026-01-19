//
//  CitiesServiceMock.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 19/01/2026.
//

import Foundation
@testable import UalaCodeChallenge

final class CitiesServiceMock: CitiesServiceProtocol {
    var stubbedResult: Result<[CityModel], Error>!

    func fetchCities() async throws -> [CityModel] {
        switch stubbedResult {
        case .success(let cities):
            return cities
        case .failure(let error):
            throw error
        case .none:
            fatalError("stubbedResult not set")
        }
    }
}
