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
struct MediaItem: Identifiable, Codable {
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
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    @State private var mediaItems: [MediaItem] = []
    
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
            Text(String(mediaItems.count) + " Documentaries")
                .font(.footnote)
                .opacity(0.6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            LazyVGrid(columns: columns, spacing: 20) {
                // Iterate over all media items and display them
                ForEach(mediaItems) { item in
                    MediaSelectionElement(
                        image: item.image,
                        title: item.title,
                        description: item.description,
                        openWindow: { openWindow(id: "DocumentaryWindow") },
                        dismissWindow: { dismissWindow(id: "MediaSelectionWindow") }
                    )
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
        if let url = Bundle.main.url(forResource: "documentaries", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode(MediaData.self, from: data)
                self.mediaItems = decodedData.documentaries
            } catch {
                print("Failed to load or decode JSON: \(error)")
            }
        } else {
            print("JSON file not found")
        }
    }
}

struct MediaSelectionElement: View {
    // Arguments passed to this view
    var image: String
    var title: String
    var description: String
    var openWindow: () -> Void
    var dismissWindow: () -> Void
    
    var body: some View {
        Button(action: {
            Task {
                // When MediaSelectionElement is clicked, wait for documentary to open before closing this window
                await openAndDismiss()
            }
        }) {
            VStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                Text(title)
                    .font(.title)
                    .padding(EdgeInsets(top: 10, leading: 14, bottom: 2, trailing: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(description)
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
    
    // Helper function for window opening/closing
    @MainActor
    private func openAndDismiss() async {
        await openWindowAsync()
        dismissWindow()
    }
    
    // Helper function for window opening/closing
    @MainActor
    private func openWindowAsync() async {
        await withCheckedContinuation { continuation in
            openWindow()
            DispatchQueue.main.async {
                continuation.resume()
            }
        }
    }
}



#Preview(windowStyle: .automatic) {
    MediaSelectionView()
}
