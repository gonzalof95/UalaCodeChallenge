//
//  CityRowView.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import SwiftUI

struct CityRowView: View {
    let city: CityModel
    let isFavorite: Bool
    let onFavoriteTapped: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(city.name), \(city.country)")
                    .font(.headline)
                    .padding(.leading, 8)
                
                Text("Lat: \(city.coord.lat), Lon: \(city.coord.lon)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.leading, 8)
            }

            Spacer()

            Button(action: onFavoriteTapped) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
            }
            .padding(.trailing, 8)
            .buttonStyle(.plain)
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
    }
}
