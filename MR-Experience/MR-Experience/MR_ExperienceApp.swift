//
//  MR_ExperienceApp.swift
//  MR-Experience
//
//  Created by Maxim Strzebkowski on 26.04.24.
//

import SwiftUI

@main
struct MR_ExperienceApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup(id: "MediaSelectionWindow") {
            MediaSelectionView(appState: appState)
        }
    
        WindowGroup(id: "DocumentaryWindow") {
            if let selectedMediaItem = appState.selectedMediaItem {
                DocumentaryView(mediaItem: selectedMediaItem)
                    .onAppear {
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                            return
                        }
                        let geometryRequest = UIWindowScene.GeometryPreferences.Vision(
                            resizingRestrictions: .uniform
                        )
                        windowScene.requestGeometryUpdate(geometryRequest)
                    }
            } else {
                EmptyView() // Ensure there's always a view to present
            }
        }
        .windowStyle(.plain)
        .defaultSize(width: 1.2, height: 0.48, depth: 0.0, in: .meters)
    }
}
