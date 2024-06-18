//
//  MR_ExperienceApp.swift
//  MR-Experience
//
//  Created by Maxim Strzebkowski on 26.04.24.
//

import SwiftUI

/// The main entry point for the MR-Experience application.
@main
struct MR_ExperienceApp: App {
    /// State object to manage the overall application state.
    @StateObject private var appState = AppState()
    
    /// The body of the application, defining different window groups.
    var body: some Scene {
        // Media selection window group
        WindowGroup(id: "MediaSelectionWindow") {
            MediaSelectionView(appState: appState)
        }
    
        // Documentary window group
        WindowGroup(id: "DocumentaryWindow") {
            if let selectedMediaItem = appState.selectedMediaItem {
                DocumentaryView(mediaItem: selectedMediaItem)
                    .onAppear {
                        // Request geometry update for the window scene. This is used to keep the aspect ratio of the window.
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
