//
//  CityMapView.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 19/01/2026.
//

import SwiftUI
import MapKit

struct CityMapView: View {
    let city: CityModel
    @Environment(\.dismiss) var dismiss
    @State private var cameraPosition: MapCameraPosition

    init(city: CityModel) {
        self.city = city

        let initialCamera = MapCamera(
            centerCoordinate: CLLocationCoordinate2D(
                latitude: city.coord.lat,
                longitude: city.coord.lon
            ),
            distance: 5000
        )

        _cameraPosition = State(initialValue: .camera(initialCamera))
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Map(position: $cameraPosition, interactionModes: .all) {
                Marker("City", coordinate: CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon))
            }
            .animation(.easeInOut(duration: 1.0), value: cameraPosition)
            //.ignoresSafeArea(edges: .all)
        }
        //.ignoresSafeArea(edges: .all)
        .onAppear {
            animateZoomToCity()
        }
    }

    private func animateZoomToCity() {
        let targetCamera = MapCamera(
            centerCoordinate: CLLocationCoordinate2D(
                latitude: city.coord.lat,
                longitude: city.coord.lon
            ),
            distance: 12000
        )

        withAnimation(.easeInOut(duration: 1.0)) {
            cameraPosition = .camera(targetCamera)
        }
    }
}

/// Used to show when a city is not yet selected in MapView, when phone is on Landscape mode
struct PlaceholderMapView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
            Text("Select a city to show on the map")
                .foregroundColor(.secondary)
                .font(.headline)
        }
    }
}
