import UIKit
import AVKit

class VideoViewController: UIViewController {
    
    private var playerLooper: AVPlayerLooper?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SplitViewBehaviourManager.showMasterInOverlay(splitViewController: splitViewController, viewHeight: view.bounds.height, viewWidth: view.bounds.width)
    }
        
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        SplitViewBehaviourManager.showMasterInOverlay(splitViewController: splitViewController, viewHeight: size.height, viewWidth: size.width)
    }
    
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
