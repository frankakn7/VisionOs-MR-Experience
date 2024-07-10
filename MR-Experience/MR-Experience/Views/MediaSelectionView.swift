//
//  ContentView.swift
//  MR-Experience
//
//  Created by Maxim Strzebkowski on 26.04.24.
//

import SwiftUI
import RealityKit
import RealityKitContent

// Define the model for the media selection item
struct MediaItem: Identifiable, Codable, Hashable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
    let markers: String?
    let videofile: String?
    
    enum CodingKeys: String, CodingKey {
        case image, title, description, markers, videofile
    }
}

// Create a structure to match the JSON file
struct MediaData: Codable {
    let documentaries: [MediaItem]
}

struct MediaSelectionView: View {
    @EnvironmentObject private var appState: AppState
    
    // Define the grid layout
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        ScrollView {
            Text("Documentaries")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 0))
            Text("\(appState.mediaItems.count) Documentaries")
                .font(.footnote)
                .opacity(0.6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            LazyVGrid(columns: columns, spacing: 20) {
                // Iterate over all media items and display them
                ForEach(appState.mediaItems) { item in
                    MediaSelectionElement(mediaItem: item)
                        .frame(height: 400)
                }
            }
            .padding()
        }
        .padding()
        .background()
        .onAppear(perform: loadMediaItems) // Load media items when the view appears
    }
    
    // Load and decode the JSON file
    func loadMediaItems() {
        guard appState.mediaItems.isEmpty else { return }
        if let url = Bundle.main.url(forResource: "documentaries", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode(MediaData.self, from: data)
                appState.mediaItems = decodedData.documentaries
            } catch {
                print("Failed to load or decode JSON: \(error)")
            }
        } else {
            print("JSON file not found")
        }
    }
}
    
struct MediaSelectionElement: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @EnvironmentObject private var appState: AppState
    // Arguments passed to this view
    var mediaItem: MediaItem
    
    var body: some View {
        Button(action: {
            appState.updateSelectedMediaItem(mediaItem)
            openWindow(id: "DocumentaryWindow")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                dismissWindow()
            }
        }) {
            VStack {
                Image(mediaItem.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                Text(mediaItem.title)
                    .font(.title)
                    .padding(EdgeInsets(top: 10, leading: 14, bottom: 2, trailing: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(mediaItem.description)
                    .padding(EdgeInsets(top: 2, leading: 14, bottom: 10, trailing: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            // Correct border radius on hover
            .contentShape(.hoverEffect, .rect(cornerRadius: 10))
            .hoverEffect()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure the element takes the full size of its parent
        .background(Color.white.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 5)
        .buttonStyle(.plain)
        
        
    }
}



// #Preview(windowStyle: .automatic) {
//     MediaSelectionView()
// }
