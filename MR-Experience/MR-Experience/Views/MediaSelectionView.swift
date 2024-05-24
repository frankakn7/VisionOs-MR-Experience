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
struct MediaItem: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
}

struct MediaSelectionView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    // Data for media items
    let mediaItems: [MediaItem] = [
        MediaItem(image: "cleopatra", title: "Cleopatra: The Story of the Queen of Egypt", description: "A figure whose name and legacy is burned into the minds of billions. Coming from a tenacious Greek Macedonian family, she had to fight and even kill for her place on the throne, a noble attempt to save a failing Egypt."),
        MediaItem(image: "jfk", title: "Assassination of John F. Kennedy", description: "Kennedy's assassination is still the subject of widespread debate and has spawned many conspiracy theories and alternative scenarios; polls found that a majority of Americans believed there was a conspiracy."),
        MediaItem(image: "medusa", title: "Greek Mythology: God and Goddesses", description: "Greek Mythology is the body of myths and teachings that belong to the ancient Greeks, concerning their gods and heroes, the nature of the world, and the origins and significance of their own cult and ritual practices."),
        MediaItem(image: "medicifamily", title: "The Medici: Godfathers of the Renaissance", description: "From a small Italian community in 15th-century Florence, the Medici family would rise to rule Europe in many ways. Using charm, patronage, skill, duplicity and ruthlessness, they would amass unparalleled wealth and unprecedented power."),
        MediaItem(image: "shakespeare", title: "Shakespeare: Rise of a Genius", description: "Taking a deep dive into Shakespeare’s life story, the place and time he inhabited and the work he produced, the series reveals a dangerous and exciting world filled with bitter rivalries, rebellion, murder and deadly plague, that ignited and nourished his creative genius."),
        MediaItem(image: "watertap", title: "The Last Resources", description: "Water is now becoming a scarce resource. Throughout man's history, stretching back to prehistoric times, no one would have thought that water would disappear and dry up. It was a resource that no one ever really worried about."),
    ]
    
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
