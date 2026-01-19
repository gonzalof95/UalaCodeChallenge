//
//  CitiesListView.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 19/01/2026.
//

import SwiftUI

struct CitiesListView<RowContent: View>: View {
    @ObservedObject var viewModel: CitiesViewModel
    let rowContent: (CityModel, Int) -> RowContent

    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(Color.white)
        .onAppear {
            Task { await viewModel.loadCities() }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            loadingView
        } else if let error = viewModel.errorMessage {
            errorView(error)
        } else {
            listView
        }
    }

    private var loadingView: some View {
        ProgressView("Loading cities…")
            .padding()
    }

    private func errorView(_ message: String) -> some View {
        Text(message)
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .padding()
    }

    private var listView: some View {
        VStack(spacing: 0) {
            CitiesSearchBar(viewModel: viewModel)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(
                        Array(viewModel.visibleCities.enumerated()),
                        id: \.element.id
                    ) { index, city in
                        rowContent(city, index)
                            .background(rowBackground(for: index))
                    }
                }
            }
            .accessibilityIdentifier("cities_list")
        }
    }

    private func rowBackground(for index: Int) -> Color {
        index.isMultiple(of: 2)
            ? .white
            : Color.gray.opacity(0.10)
    }
}
