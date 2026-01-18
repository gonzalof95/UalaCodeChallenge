//
//  Model.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import Foundation

struct City: nonisolated Decodable, Identifiable {
    let id: Int
    let name: String
    let country: String
    let coord: Coordinate

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case country
        case coord
    }
}

struct Coordinate: Decodable {
    let lon: Double
    let lat: Double
}
