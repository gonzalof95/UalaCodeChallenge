//
//  CitiesSearchBar.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 19/01/2026.
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
