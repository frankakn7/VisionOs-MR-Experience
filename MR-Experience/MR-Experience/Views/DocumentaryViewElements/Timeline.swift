//
//  Timeline.swift
//  MR-Experience
//
//  Created by Christian Helbig on 03.05.24.
//

import SwiftUI

/// A view representing a horizontal timeline with selectable elements.
struct Timeline: View {
    let timestamps: [String: Timestamp]                 // Dictionary mapping timestamp strings to Timestamp objects
    let timelineElements: [String: TimelineElement]     // Dictionary mapping keys to TimelineElement objects
    let onSelectTimestamp: (String, Timestamp) -> Void  // Function to call when a timestamp is selected
    
    @Binding var currentHighlight: Int                  // Track the current highlighted element in timeline
    
    var body: some View {
        // Scrollable horizontal stack to display timeline elements
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 50) {
                Spacer(minLength: 0)  // Leading spacer
                
                // Iterate over sorted timeline elements by key
                ForEach(timelineElements.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    ZStack {
                        // Highlight background for the current element
                        if currentHighlight == Int(key) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.2))
                        }
                        
                        VStack {
                            // Display datetime and text of the timeline element
                            Text(timelineElements[key]!.datetime)
                                .bold()
                                .font(.headline)
                            Text(timelineElements[key]!.text)
                                .multilineTextAlignment(.center)
                                .italic()
                        }
                        .padding()
                    }
                    .fixedSize()
                    // Add tap gesture to the element
                    .onTapGesture {
                        // Check if key can be converted to an integer
                        if let intKey = Int(key) {
                            // Filter timestamps with the same timeline_highlight
                            let sameHighlightElements = timestamps.filter { $0.value.timeline_highlight == intKey }
                            // Find the smallest timestamp key and corresponding timestamp
                            if let smallestTimestampKey = sameHighlightElements.keys.sorted().first,
                               let correspondingTimestamp = timestamps[smallestTimestampKey] {
                                // Execute the function to change video position
                                onSelectTimestamp(smallestTimestampKey, correspondingTimestamp)
                            }
                        }
                    }
                }
                Spacer(minLength: 0)  // Trailing spacer
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
