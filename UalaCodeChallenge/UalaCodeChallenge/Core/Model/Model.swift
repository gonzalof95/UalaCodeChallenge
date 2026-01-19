//
//  Model.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import Foundation

struct CityModel: nonisolated Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let country: String
    let coord: CityCoordinate

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case country
        case coord
    }
}

struct CityCoordinate: Decodable, Hashable {
    let lon: Double
    let lat: Double
}
