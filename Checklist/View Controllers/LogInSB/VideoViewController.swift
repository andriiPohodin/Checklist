//
//  VideoViewController.swift
//  Checklist
//
//  Created by Andrii Pohodin on 03.12.2021.
//

import UIKit
import AVKit

class VideoViewController: UIViewController {
    
    var playerLooper: AVPlayerLooper?
    
    override func viewDidLayoutSubviews() {
        setUpVideo()
    }
    
    func setUpVideo() {
        if UIDevice.current.userInterfaceIdiom == .pad || UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            view.isHidden = false
            guard let bundlePath = Bundle.main.path(forResource: "My Movie", ofType: "mp4") else { return }
            let url = URL(fileURLWithPath: bundlePath)
            let item = AVPlayerItem(url: url)
            let player = AVQueuePlayer(playerItem: item)
            let layer = AVPlayerLayer(player: player)
            layer.frame = view.bounds
            layer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(layer)
            playerLooper = AVPlayerLooper(player: player, templateItem: item)
            player.playImmediately(atRate: 2)
        }
        else {
            view.isHidden = true
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
