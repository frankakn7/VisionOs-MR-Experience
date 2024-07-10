//
//  DocumentaryView.swift
//  MR-Experience
//
//  Created by Christian Helbig on 06.05.24.
//

import SwiftUI
import AVKit

/// A view representing a documentary experience for a specific `MediaItem`.
struct DocumentaryView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    
    let mediaItem: MediaItem                                    // The media item associated with this documentary view
    
    @Binding var current3DPath: String
    
    @Binding var threeDObjectOpen: Bool;
    
    @State private var markerData: MarkerData?                  // State variable to hold marker data parsed from JSON
    @State private var currentInformation: String = ""          // Currently displayed information text
    //@State private var current3DPath: String = "Flora"               // Path to currently displayed 3D object
    @State private var currentMapElement: MapElement?           // MapElement containing map information for currently displayed map
    @State private var isLoading = true
    @State private var player: AVPlayer?
    @State private var currentHighlight: Int = 0                // Track the current highlighted element in timeline
    
    var body: some View {
        VStack(spacing: 25) {
            // Check if marker data is loaded
            if let markerData = markerData, !isLoading {
                // Only load subviews if the video file path is set
                if mediaItem.videofile != nil {
                    // Timeline view showing timestamps at top of view
                    Timeline(timestamps: markerData.timestamps,
                             timelineElements: markerData.timelineElements,
                             onSelectTimestamp: handleTimestampSelection,
                             currentHighlight: $currentHighlight)
                        .relativeProposed(height: 0.20)
                        .layoutPriority(1)
                        .glassBackgroundEffect()
                    
                    // Horizontal stack for context map and documentary content
                    HStack(spacing: 25) {
                        // Context map view if available, otherwise display a message
                        if let mapElement = currentMapElement {
                            ContextMap(mapElement: mapElement)
                                .glassBackgroundEffect()
                        } else {
                            Text("No map set")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .glassBackgroundEffect()
                        }
                        
                        // Main documentary view displaying video
                        // Pass state variables to update them when video markers are reached
                        Documentary(mediaItem: mediaItem,
                                    markers: markerData,
                                    currentInformation: $currentInformation,
                                    current3DPath: $current3DPath,
                                    currentMapElement: $currentMapElement,
                                    player: $player,
                                    currentHighlight: $currentHighlight)
                        .relativeProposed(width: 0.6)
                        .layoutPriority(1)
                        .glassBackgroundEffect()
                        
                        // Vertical stack for information text and 3D object view
                        VStack(spacing: 25) {
                            // Information text related to the current timestamp
                            Information(informationText: currentInformation)
                                .glassBackgroundEffect()
                            
                            // 3D object view based on the current 3D path
                            ThreeDObject(objectFileName: $current3DPath, threeDObjectOpened: $threeDObjectOpen)
                                .relativeProposed(height: 0.5)
                                .layoutPriority(1)
                        }
                        
                    }
                } else {
                    // Display message when video path is not set
                    Text("Video path not set")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .glassBackgroundEffect()
                }
            } else {
                // Show loading indicator while markers are being loaded
                ProgressView("Loading...")
                    .onAppear {
                        // Load and parse markers JSON
                        loadMarkers()
                    }
            }
            // bottom toolbar
                HStack {
                    Button(action: {
                        goBack()
                    }) {
                        Image(systemName: "arrow.backward")
                    }
                    .disabled(isFirstMediaItem)
                    
                    Button(action: {
                        backToMediaSelection()
                    }) {
                        Image(systemName: "house")
                    }
                    
                    Button(action: {
                        goForward()
                    }) {
                        Image(systemName: "arrow.forward")
                    }
                    .disabled(isLastMediaItem)
                }
            }
        .task(id: mediaItem) {
            resetState()
            loadMarkers()
            isLoading = false
        }
        
    }
        
        /// Loads and parses marker data from a JSON file of the associated `MediaItem`
    private func loadMarkers() {
        guard let markersFileName = mediaItem.markers else {
            return
        }
        
        // Remove ".json" extension if it exists in the markers file name
        let markersFilePath = markersFileName.replacingOccurrences(of: ".json", with: "")
        
        // Split path into components to extract directory and filename
        let pathComponents = markersFilePath.split(separator: "/")
        let fileName = String(pathComponents.last ?? "")
        let directory = pathComponents.dropLast().joined(separator: "/")
        
        // Print debug information about the attempted markers JSON load
        print("Attempting to load markers JSON from path: \(directory)/\(fileName).json")
        
        // Attempt to load JSON data from the specified file path
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json", subdirectory: directory) {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                markerData = try decoder.decode(MarkerData.self, from: data)
                
                // Set initial information, 3D path, and map element based on the first timestamp
                if let initialTimestamp = markerData?.timestamps["0"] {
                    currentInformation = initialTimestamp.information
                    current3DPath = initialTimestamp._3dpath
                    currentMapElement = markerData?.mapElements[String(initialTimestamp.map_content)]
                }
                print(current3DPath)
            } catch {
                print("Failed to load or decode markers JSON: \(error)")
            }
        } else {
            print("Markers JSON file not found at path: \(directory)/\(fileName).json")
        }
    }
    
    var isFirstMediaItem: Bool {
        appState.mediaItems.first == mediaItem
    }

    var isLastMediaItem: Bool {
        appState.mediaItems.last == mediaItem
    }

    private func goBack() {
        guard let index = appState.mediaItems.firstIndex(of: mediaItem) else { return }
        guard index > 0 else { return }
        appState.updateSelectedMediaItem(appState.mediaItems[index - 1])
        isLoading = true
    }

    private func goForward() {
        guard let index = appState.mediaItems.firstIndex(of: mediaItem) else { return }
        guard index < appState.mediaItems.count - 1 else { return }
        appState.updateSelectedMediaItem(appState.mediaItems[index + 1])
        isLoading = true
    }

    private func backToMediaSelection() {
        appState.updateSelectedMediaItem(nil)
        openWindow(id: "MediaSelectionWindow")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            dismissWindow()
        }
    }

    private func resetState() {
        markerData = nil
        currentInformation = ""
        current3DPath = ""
        currentMapElement = nil
    }
    
    /// Handles the selection of a timestamp from the timeline and updates the player position accordingly.
    /// - Parameters:
    ///   - selectedTimestamp: The timestamp selected from the timeline in string format.
    ///   - timeStamp: The optional `Timestamp` object associated with the selected timestamp.
    private func handleTimestampSelection(selectedTimestamp: String, timeStamp: Timestamp?) {
        // Ensure the `timeStamp` is not nil and convert the selected timestamp to a Double.
        if let timeInSeconds = Double(selectedTimestamp) {
            print("Seeking to time \(timeInSeconds)")
            
            // Ensure player is not nil
            guard let player = player else {
                print("Player is nil")
                return
            }

            // Seek the player to the corresponding time in seconds with millisecond precision.
            let seekTime = CMTime(seconds: timeInSeconds, preferredTimescale: 1000)
            player.seek(to: seekTime) { completed in
                print("Seek operation completed: \(completed)")
                // If the seek operation is completed, start playing the video.
                if completed {
                    player.play()
                } else {
                    print("Seek operation failed or was interrupted")
                }
            }
        }
    }
}
