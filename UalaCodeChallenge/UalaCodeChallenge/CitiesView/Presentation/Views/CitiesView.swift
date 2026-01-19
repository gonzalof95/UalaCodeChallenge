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

    var body: some View {
        CitiesListView(viewModel: viewModel) { city, _ in
            NavigationLink(value: city) {
                CityRowView(
                    city: city,
                    isFavorite: viewModel.isFavorite(city),
                    onFavoriteTapped: { viewModel.toggleFavorite(city) }
                )
                .padding(.leading, 8)
            }
            .buttonStyle(.plain)
        }
        .navigationDestination(for: CityModel.self) { city in
            CityMapView(city: city)
        }
    }
}

struct LandscapeCitiesView: View {
    @ObservedObject var viewModel: CitiesViewModel
    @State private var selectedCity: CityModel? = nil

    var body: some View {
        HStack(spacing: 0) {

            CitiesListView(viewModel: viewModel) { city, _ in
                Button {
                    selectedCity = city
                } label: {
                    CityRowView(
                        city: city,
                        isFavorite: viewModel.isFavorite(city),
                        onFavoriteTapped: { viewModel.toggleFavorite(city) }
                    )
                    .padding(.horizontal, 8)
                }
                .buttonStyle(.plain)
            }
            .frame(width: screenBounds.width / 2)

            Group {
                if let city = selectedCity {
                    CityMapView(city: city)
                        .id(city.id)
                } else {
                    PlaceholderMapView()
                }
            }
            .frame(width: screenBounds.width / 2)
        }
    }
}
