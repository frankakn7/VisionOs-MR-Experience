import SwiftUI
import AVKit

/// A view for displaying a documentary video
struct VideoPlayerView: UIViewControllerRepresentable {
    // The URL of the video to be played.
    let videoURL: URL
    
    // Dictionary mapping timestamps to actions.
    let markerData: MarkerData
    
    @Binding var currentInformation: String         // Binding for the current information displayed in the video player
    @Binding var current3DPath: String              // Binding for the current 3D object path displayed in the video player
    @Binding var currentMapElement: MapElement?     // Binding for the current map element displayed in the video player.
    
    /// Creates a view controller instance with an `AVPlayer` configured to play the provided video.
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer(url: videoURL)
        playerViewController.player = player
        
        // Add observer to track time changes and trigger actions based on timestamps
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: nil) { time in
            let currentTime = Int(time.seconds)
            let availableTimestamps = Array(markerData.timestamps.keys)
            var maxTimestamp = 0
            
            // find biggest timestamp that is <= currentTime
            for el in availableTimestamps {
                if (Int(el) != nil) {
                    if (Int(el)! <= currentTime && Int(el)! > maxTimestamp) {
                        maxTimestamp = Int(el)!
                    }
                }
            }
            
            // display content
            if let timestamp = markerData.timestamps[String(maxTimestamp)] {
                DispatchQueue.main.async {
                    currentInformation = timestamp.information
                    current3DPath = timestamp._3dpath
                    currentMapElement = markerData.mapElements[String(timestamp.map_content)]
                }
            }
        }
        
        return playerViewController
    }
    
    /// Updates the view controller with any new information, if needed.
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Needed later when the video url is changed
        // TODO: This function should change the video URL when a user closes a documentary and selects another one.
    }
}

/// A view for displaying a documentary video.
struct Documentary: View {
    /// The media item containing video file name
    let mediaItem: MediaItem
    
    /// The video markers and data
    let markers: MarkerData
    
    @Binding var currentInformation: String         // Binding for the current information displayed in the video player
    @Binding var current3DPath: String              // Binding for the current 3D object path displayed in the video player
    @Binding var currentMapElement: MapElement?     // Binding for the current map element displayed in the video player.
    
    /// Computed property to retrieve the file path of the video based on `mediaItem.videofile`.
    var videoFilePath: String? {
        var videoFileName = mediaItem.videofile ?? ""
        
        // Remove ".mp4" extension if present
        if videoFileName.hasSuffix(".mp4") {
            videoFileName = String(videoFileName.dropLast(4))
        }
        
        // Return the path of the video file in the main bundle
        return Bundle.main.path(forResource: videoFileName, ofType: "mp4")
    }

    var body: some View {
        if let path = videoFilePath {
            let url = URL(fileURLWithPath: path)
            VideoPlayerView(videoURL: url, markerData: markers, currentInformation: $currentInformation, current3DPath: $current3DPath, currentMapElement: $currentMapElement)
                .edgesIgnoringSafeArea(.all)
        } else {
            // Display message when video file is not found
            Text("Video not found")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .glassBackgroundEffect()
        }
    }
}
