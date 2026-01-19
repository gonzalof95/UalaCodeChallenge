//
//  MainView.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import SwiftUI

struct CityRowView: View {
    let city: City
    let isFavorite: Bool
    let onFavoriteTapped: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(city.name), \(city.country)")
                    .font(.headline)

                Text("Lat: \(city.coord.lat), Lon: \(city.coord.lon)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: onFavoriteTapped) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
    }
}

struct CitiesView: View {
    @ObservedObject var viewModel: CitiesViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {

                ProgressView("Loading cities…")
                    .padding()

            } else if let error = viewModel.errorMessage {

                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()

            } else {
                List {
                    ForEach(Array(viewModel.visibleCities.enumerated()), id: \.element.id) { index, city in
                        CityRowView(
                            city: city,
                            isFavorite: viewModel.isFavorite(city),
                            onFavoriteTapped: {
                                viewModel.toggleFavorite(city)
                            }
                        )
                        .listRowInsets(EdgeInsets()) // full width
                        .background(
                            index.isMultiple(of: 2)
                                ? Color.white
                                : Color.gray.opacity(0.05)
                        )
                    }
                }
                .listStyle(.plain)
            }
        }
        .background(Color.white)
        .searchable(text: $viewModel.searchText, prompt: "Search cities")
        .onAppear {
            viewModel.loadCities()
        }
    }
}
