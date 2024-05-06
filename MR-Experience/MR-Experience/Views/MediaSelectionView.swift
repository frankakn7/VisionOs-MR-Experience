//
//  ContentView.swift
//  MR-Experience
//
//  Created by Maxim Strzebkowski on 26.04.24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct MediaSelectionView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    var body: some View {
        Button(action: {
            openWindow(id: "DocumentaryWindow")
            dismissWindow(id: "MediaSelectionWindow")
        }) {
            Text("Klick me")
                .font(.system(size: 40))
            .padding()
        }
    }
}

#Preview(windowStyle: .automatic) {
    MediaSelectionView()
}
