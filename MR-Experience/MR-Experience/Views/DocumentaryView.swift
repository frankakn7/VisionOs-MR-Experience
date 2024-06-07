//
//  DocumentaryView.swift
//  MR-Experience
//
//  Created by Christian Helbig on 06.05.24.
//

import SwiftUI

struct DocumentaryView: View {
    var body: some View {
        VStack(spacing: 25) {
                Timeline()
                .relativeProposed(height: 0.20)
                .layoutPriority(1)
                .glassBackgroundEffect()
                HStack(spacing: 25) {
                    ContextMap()
                        .glassBackgroundEffect()
                    // added testvideo, needs to be replaced dynamically
                    Documentary(videoFileName: "cleopatra_testvideo")
                        .relativeProposed(width: 0.6)
                        .layoutPriority(1)
                        .glassBackgroundEffect()
                    VStack(spacing: 25) {
                        Information()
                            .glassBackgroundEffect()
                        ThreeDObject()
                            .relativeProposed(height: 0.5)
                            .layoutPriority(1)
                    }
                }
            }
    }
}

#Preview {
    DocumentaryView()
}
