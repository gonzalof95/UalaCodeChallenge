//
//  ContentView.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import SwiftUI

enum AppContainer {
    static func makeCitiesViewModel() -> CitiesViewModel {
        guard let url = URL(
            string: "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
        ) else {
            fatalError("Invalid cities URL configuration")
        }

        let client = URLSessionNetworkClient()
        let repository = CitiesRepository(client: client, url: url)
        let service = CitiesService(repository: repository)

        return CitiesViewModel(service: service)
    }
}

struct ContentView: View {
    var body: some View {
        CitiesView(viewModel: AppContainer.makeCitiesViewModel())
    }
}

#Preview {
    ContentView()
}
