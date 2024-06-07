//
//  Documentary.swift
//  MR-Experience
//
//  Created by Christian Helbig on 03.05.24.
//

import SwiftUI
import AVKit

/// A `UIViewControllerRepresentable` view that displays a video player.
struct VideoPlayerView: UIViewControllerRepresentable {
    /// The URL of the video to be played.
    let videoURL: URL
    
    /// Creates a view controller instance with an `AVPlayer` configured to play the provided video.
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer(url: videoURL)
        playerViewController.player = player
        return playerViewController
    }
    
    /// Updates the view controller with any new information, if needed.
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Needed later when the video url is changed
    }
}

/// A view for displaying a documentary video.
struct Documentary: View {
    /// The file name of the video to be displayed.
    let videoFileName: String
    
    /// Initializes the `Documentary` view with the provided video file name.
    init(videoFileName: String) {
        self.videoFileName = videoFileName
    }
    
    var body: some View {
        // If the path exists, display the video, otherwise show an error message
        if let path = Bundle.main.path(forResource: videoFileName, ofType: "mp4") {
            let url = URL(fileURLWithPath: path)
            VideoPlayerView(videoURL: url)
                .edgesIgnoringSafeArea(.all)
        } else {
            Text("Video not found")
        }
    }
}

#Preview {
    // Preview uses a testvideo
    Documentary(videoFileName: "cleopatra_testvideo")
}
