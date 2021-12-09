import UIKit
import AVKit

class VideoViewController: UIViewController {
    
    var playerLooper: AVPlayerLooper?
    
    override func viewDidLayoutSubviews() {
        SplitViewManager.showMasterInOverlay(splitViewController: splitViewController, viewBounds: view.bounds)
        setUpVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerLooper = nil
    }
    
    func setUpVideo() {
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            playerLooper = VideoManager.play(onSuperview: view, forResource: "My Movie", ofType: "mp4")
        }
    }
}
