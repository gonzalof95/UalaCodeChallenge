//
//  CityMapViewModel.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 19/01/2026.
//

import Foundation
import SwiftUI
import MapKit
import Combine

final class CityMapViewModel: ObservableObject {
    @Published var cameraPosition: MapCameraPosition

    init(city: City) {
        let initialCamera = MapCamera(
            centerCoordinate: CLLocationCoordinate2D(
                latitude: city.coord.lat,
                longitude: city.coord.lon
            ),
            distance: 5000
        )

        cameraPosition = .camera(initialCamera)
        zoomToCity(city: city)
    }

    func zoomToCity(city: City) {
        let targetCamera = MapCamera(
            centerCoordinate: CLLocationCoordinate2D(
                latitude: city.coord.lat,
                longitude: city.coord.lon
            ),
            distance: 12000
        )

        cameraPosition = .camera(targetCamera) // SwiftUI animates automatically
    }
}
