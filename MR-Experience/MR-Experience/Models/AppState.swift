//
//  AppState.swift
//  MR-Experience
//
//  Created by Christian Helbig on 14.06.24.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var selectedMediaItem: MediaItem?
    
    func updateSelectedMediaItem(_ mediaItem: MediaItem) {
        selectedMediaItem = mediaItem
    }
}
