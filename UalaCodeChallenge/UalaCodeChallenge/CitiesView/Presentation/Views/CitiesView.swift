//
//  CitiesView.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import SwiftUI

struct CitiesSearchBar: View {
    @ObservedObject var viewModel: CitiesViewModel

    var body: some View {
        HStack {
            TextField("Search cities", text: $viewModel.searchText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Button(action: { viewModel.showFavoritesOnly.toggle() }) {
                Image(systemName: viewModel.showFavoritesOnly ? "heart.fill" : "heart")
                    .foregroundColor(viewModel.showFavoritesOnly ? .red : .gray)
                    .padding(.trailing)
            }
            .buttonStyle(.plain)
            .help("Show only favorites")
        }
        .padding(.vertical, 4)
    }
}

struct CitiesView: View {
    @ObservedObject var viewModel: CitiesViewModel

    var body: some View {
        GeometryReader { geometry in
            let isPortrait = geometry.size.height >= geometry.size.width

            NavigationStack {
                if isPortrait {
                    portraitView()
                } else {
                    // Landscape placeholder for now
                    LandscapeCitiesView(viewModel: viewModel)
                }
            }
        }
    }

    @ViewBuilder
    private func portraitView() -> some View {
        VStack(spacing: 8) {
            if viewModel.isLoading {
                ProgressView("Loading cities…")
                    .padding()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                CitiesSearchBar(viewModel: viewModel)
                    .padding(.vertical, 4)
                    .padding(.trailing, 8)

                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(viewModel.visibleCities.enumerated()), id: \.element.id) { index, city in
                            NavigationLink(value: city) {
                                CityRowView(
                                    city: city,
                                    isFavorite: viewModel.isFavorite(city),
                                    onFavoriteTapped: { viewModel.toggleFavorite(city) }
                                )
                                .padding(.leading, 8)
                                .background(
                                    index.isMultiple(of: 2) ? Color.white : Color.gray.opacity(0.10)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .background(Color.white)
        .navigationDestination(for: CityModel.self) { city in
            CityMapView(city: city)
        }
        .onAppear { Task { await viewModel.loadCities() } }
    }
}

struct LandscapeCitiesView: View {
    @ObservedObject var viewModel: CitiesViewModel
    @State private var selectedCity: CityModel? = nil

    var body: some View {
        HStack(spacing: 0) {
            // Left side: city list
            VStack(spacing: 0) {
                CitiesSearchBar(viewModel: viewModel)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)

                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(viewModel.visibleCities.enumerated()), id: \.element.id) { index, city in
                            Button {
                                selectedCity = city
                            } label: {
                                CityRowView(
                                    city: city,
                                    isFavorite: viewModel.isFavorite(city),
                                    onFavoriteTapped: { viewModel.toggleFavorite(city) }
                                )
                                .background(
                                    index.isMultiple(of: 2) ? Color.white : Color.gray.opacity(0.10)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)

            // Right side: Map or placeholder
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
            .frame(maxWidth: .infinity)

        }
        .onAppear { Task { await viewModel.loadCities() } }
    }
}
