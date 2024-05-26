//
//  MR_ExperienceApp.swift
//  MR-Experience
//
//  Created by Maxim Strzebkowski on 26.04.24.
//

import SwiftUI

@main
struct MR_ExperienceApp: App {
    var body: some Scene {
        WindowGroup(id: "MediaSelectionWindow") {
             MediaSelectionView()
        }
    
        WindowGroup(id: "DocumentaryWindow") {
            DocumentaryView()
                .onAppear() {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                        return
                     }
                     let geometryRequest = UIWindowScene.GeometryPreferences.Vision(
                          // addition parameters: size, max size ...
                          resizingRestrictions: .uniform // maintain aspect ratio when resizing
                     )
                                    
                     windowScene.requestGeometryUpdate(geometryRequest)
                }
        }
        .windowStyle(.plain)
        .defaultSize(width: 1.2, height: 0.48, depth: 0.0, in: .meters)
    }
}
