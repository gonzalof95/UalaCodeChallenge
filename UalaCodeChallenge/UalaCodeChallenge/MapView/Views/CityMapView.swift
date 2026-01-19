//
//  CityMapView.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 19/01/2026.
//

import SwiftUI
import MapKit

struct CityMapView: View {
    @ObservedObject var viewModel: CityMapViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .topLeading) {
            Map(position: $viewModel.cameraPosition, interactionModes: .all) {
                Marker("City", coordinate: viewModel.cameraPosition.camera?.centerCoordinate ?? .init(latitude: 0, longitude: 0))
            }
            .ignoresSafeArea()
        }
    }
}
