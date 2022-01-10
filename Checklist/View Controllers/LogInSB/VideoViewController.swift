import UIKit
import AVKit

class VideoViewController: UIViewController {
    
    private var playerLooper: AVPlayerLooper?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerLooper = nil
    }
    
    private func setUpVideo() {
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            playerLooper = VideoManager.play(onSuperview: view, forResource: "My Movie", ofType: "mp4")
        }
    }
}
