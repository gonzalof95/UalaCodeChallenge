//
//  CitiesView.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import SwiftUI

struct CitiesView: View {
    @ObservedObject var viewModel: CitiesViewModel

    var body: some View {
        GeometryReader { geometry in
            let isPortrait = geometry.size.height >= geometry.size.width

            NavigationStack {
                if isPortrait {
                    PortraitCitiesView(viewModel: viewModel)
                } else {
                    LandscapeCitiesView(viewModel: viewModel)
                }
            }
        }
    }
}

struct PortraitCitiesView: View {
    @ObservedObject var viewModel: CitiesViewModel
    @State private var selectedCity: CityModel?

    var body: some View {
        CitiesListView(viewModel: viewModel) { city, _ in
            CityRowView(
                city: city,
                isFavorite: viewModel.isFavorite(city),
                onFavoriteTapped: {
                    viewModel.toggleFavorite(city)
                }
            )
            .accessibilityIdentifier("city_row_\(city.id)")
            .contentShape(Rectangle())
            .onTapGesture {
                selectedCity = city
            }
        }
        .navigationDestination(item: $selectedCity) { city in
            CityMapView(city: city)
                .accessibilityIdentifier("city_map")
        }
    }
}

struct LandscapeCitiesView: View {
    @ObservedObject var viewModel: CitiesViewModel
    @State private var selectedCity: CityModel? = nil

    var body: some View {
        HStack(spacing: 0) {
            // Left side of screen
            CitiesListView(viewModel: viewModel) { city, _ in
                Button {
                    selectedCity = city
                } label: {
                    CityRowView(
                        city: city,
                        isFavorite: viewModel.isFavorite(city),
                        onFavoriteTapped: {
                            viewModel.toggleFavorite(city)
                        }
                    )
                    .accessibilityIdentifier("city_row_\(city.id)")
                    .padding(.horizontal, 8)
                }
                .buttonStyle(.plain)
            }
            .frame(maxHeight: .infinity)
            .frame(
                width: screenBounds.width / 2,
                height: screenBounds.height
            )
            .background(Color.white)

            // Rigth side of screen
            Group {
                if let city = selectedCity {
                    CityMapView(city: city)
                        .id(city.id)
                } else {
                    ZStack {
                        Color.gray.opacity(0.1)
                        Text("Select a city to show on the map")
                            .foregroundColor(.secondary)
                            .font(.headline)
                    }
                }
            }
            .frame(
                width: screenBounds.width / 2,
                height: screenBounds.height
            )
        }
        .onAppear {
            Task { await viewModel.loadCities() }
        }
    }
}
