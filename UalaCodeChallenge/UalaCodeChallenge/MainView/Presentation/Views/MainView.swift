//
//  MainView.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import SwiftUI

struct CitiesView: View {
    @ObservedObject var viewModel: CitiesViewModel

    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isLoading {
                
                ProgressView("Loading cities…")
                
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)

            } else {
                List(viewModel.cities) { city in
                    VStack(alignment: .leading) {
                        Text(city.name)
                            .font(.headline)
                        Text(city.country)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.loadCities()
        }
    }
}
