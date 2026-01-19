//
//  CityMapView.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 19/01/2026.
//

import SwiftUI
import MapKit

struct CityMapView: View {
    let city: City
    @Environment(\.dismiss) var dismiss
    @State private var cameraPosition: MapCameraPosition

    init(city: City) {
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
            .ignoresSafeArea()
        }
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
