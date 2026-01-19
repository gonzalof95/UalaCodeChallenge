//
//  MainView.swift
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
        NavigationStack { // Navigation context
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
                    
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(Array(viewModel.visibleCities.enumerated()), id: \.element.id) { index, city in
                                // Wrap the row in a NavigationLink
                                NavigationLink(value: city) {
                                    CityRowView(
                                        city: city,
                                        isFavorite: viewModel.isFavorite(city),
                                        onFavoriteTapped: { viewModel.toggleFavorite(city) }
                                    )
                                    .background(
                                        index.isMultiple(of: 2) ? Color.white : Color.gray.opacity(0.10)
                                    )
                                }
                                .buttonStyle(.plain) // removes default highlight effect
                            }
                        }
                    }
                }
            }
            .background(Color.white)
            .navigationDestination(for: City.self) { city in
                let mapVM = CityMapViewModel(city: city)
                CityMapView(viewModel: mapVM)
            }
            .onAppear { Task { await viewModel.loadCities() } }
        }
    }
}

