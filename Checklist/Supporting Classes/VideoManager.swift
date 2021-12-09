import AVKit
import UIKit

class VideoManager {
    
    static func play(onSuperview superview: UIView, forResource name: String, ofType type: String) -> AVPlayerLooper? {
        guard let bundlePath = Bundle.main.path(forResource: name, ofType: type) else { return nil }
        let url = URL(fileURLWithPath: bundlePath)
        let item = AVPlayerItem(url: url)
        let player = AVQueuePlayer(playerItem: item)
        let layer = AVPlayerLayer(player: player)
        layer.frame = superview.bounds
        layer.videoGravity = .resizeAspectFill
        superview.layer.addSublayer(layer)
        let looper = AVPlayerLooper(player: player, templateItem: item)
        player.playImmediately(atRate: 2)
        return looper
    }
}
