//
//  CitiesListView.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 19/01/2026.
//

import SwiftUI

struct CitiesListView<RowAction: View>: View {
    @ObservedObject var viewModel: CitiesViewModel
    let rowAction: (CityModel, Int) -> RowAction

    var body: some View {
        VStack(spacing: 0) {
            CitiesSearchBar(viewModel: viewModel)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)

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
            ProgressView("Loading cities…")
                .padding()
        } else if let error = viewModel.errorMessage {
            Text(error)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(
                        Array(viewModel.visibleCities.enumerated()),
                        id: \.element.id
                    ) { index, city in
                        rowAction(city, index)
                            .background(rowBackground(for: index))
                    }
                }
            }
        }
    }

    private func rowBackground(for index: Int) -> Color {
        index.isMultiple(of: 2)
            ? .white
            : Color.gray.opacity(0.10)
    }
}

