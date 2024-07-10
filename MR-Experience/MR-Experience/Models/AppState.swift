//
//  AppState.swift
//  MR-Experience
//
//  Created by Christian Helbig on 14.06.24.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var mediaItems: [MediaItem] = []
    @Published var selectedMediaItem: MediaItem?
    
    @Published var threeDObjectFilePath: String = "Flora";
    @Published var threeDObjectOpened: Bool = false;
    
    func updateSelectedMediaItem(_ mediaItem: MediaItem?) {
        selectedMediaItem = mediaItem
    }
}
