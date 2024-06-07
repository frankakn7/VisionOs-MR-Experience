import SwiftUI
import AVKit

/// A `UIViewControllerRepresentable` view that displays a video player.
struct VideoPlayerView: UIViewControllerRepresentable {
    /// The URL of the video to be played.
    let videoURL: URL

    /// Dictionary mapping timestamps to actions.
    let timestamps: [Int: String]

    /// Creates a view controller instance with an `AVPlayer` configured to play the provided video.
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer(url: videoURL)
        playerViewController.player = player

        // Add observer to track time changes and trigger actions based on timestamps
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: nil) { time in
            // Check if current time matches any timestamp
            if let action = timestamps[Int(time.seconds)] {
                // Trigger action when the timestamp is reached
                // TODO: Only for demo right now. Trigger view updates here.
                print("Action triggered at second \(Int(time.seconds)): \(action)")
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
    /// The file name of the video to be displayed.
    let videoFileName: String

    /// Dictionary mapping timestamps to actions.
    let timestamps: [Int: String]

    /// Initializes the `Documentary` view with the provided video file name and timestamps.
    init(videoFileName: String, timestamps: [Int: String]) {
        self.videoFileName = videoFileName
        self.timestamps = timestamps
    }

    var body: some View {
        // If the path exists, display the video, otherwise show an error message
        if let path = Bundle.main.path(forResource: videoFileName, ofType: "mp4") {
            let url = URL(fileURLWithPath: path)
            VideoPlayerView(videoURL: url, timestamps: timestamps)
                .edgesIgnoringSafeArea(.all)
        } else {
            Text("Video not found")
        }
    }
}

// Example usage
struct ContentView: View {
    // Dictionary mapping timestamps to actions. TODO: This is only a demo and should be read dynamically from a json file.
    let timestamps: [Int: String] = [
        10: "Update View A",
        30: "Update View B"
    ]

    var body: some View {
        // Preview uses a test video and demo timestamps
        Documentary(videoFileName: "cleopatra_testvideo", timestamps: timestamps)
    }
}
