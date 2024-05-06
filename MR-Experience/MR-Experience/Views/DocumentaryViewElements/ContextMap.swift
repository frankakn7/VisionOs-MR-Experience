//
//  ContextMap.swift
//  MR-Experience
//
//  Created by Christian Helbig on 03.05.24.
//

import SwiftUI
import MapKit

struct ContextMap: View {
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 30.0131, longitude: 31.2089),
            // span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1),
            latitudinalMeters: CLLocationDistance(exactly: 250000)!,
            longitudinalMeters: CLLocationDistance(exactly: 250000)!
        )
    )
    
    var body: some View {
        Map(position: $position, interactionModes: [.rotate, .zoom]) {
            Marker("Great Sphinx of Giza", coordinate: CLLocationCoordinate2D(latitude: 30.0131, longitude: 31.2089))
                .tint(.orange)
        }
        .mapControlVisibility(.hidden)
        .mapStyle(.hybrid(elevation: .realistic))
    }
}

#Preview {
    ContextMap()
}
