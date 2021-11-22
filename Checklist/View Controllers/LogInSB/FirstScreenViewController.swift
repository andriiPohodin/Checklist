import UIKit
import AVKit

class FirstScreenViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var logInBtn: UIButton! {
        didSet {
            logInBtn.layer.cornerRadius = CGFloat(logInBtn.frame.height/2)
            logInBtn.layer.backgroundColor = UIColor.systemGreen.cgColor
            logInBtn.setTitleColor(.white, for: .normal)
            logInBtn.titleLabel?.font = UIFont.systemFont(ofSize: 25)
            logInBtn.setTitle("logIn".localized, for: .normal)
        }
    }
    @IBOutlet weak var signUpBtn: UIButton! {
        didSet {
            signUpBtn.layer.cornerRadius = CGFloat(signUpBtn.frame.height/2)
            signUpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 22)
            signUpBtn.setTitle("signUp".localized, for: .normal)
            signUpBtn.setTitleColor(.systemRed, for: .normal)
        }
    }
    var playerLooper: AVPlayerLooper?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVideo()
    }
    
    func setUpVideo() {
        guard let bundlePath = Bundle.main.path(forResource: "My Movie", ofType: "mp4") else { return }
        let url = URL(fileURLWithPath: bundlePath)
        let item = AVPlayerItem(url: url)
        let player = AVQueuePlayer(playerItem: item)
        let layer = AVPlayerLayer(player: player)
        layer.frame = contentView.bounds
        layer.videoGravity = .resizeAspectFill
        contentView.layer.addSublayer(layer)
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        player.playImmediately(atRate: 2)
        activityIndicator.stopAnimating()
    }
    
    @IBAction func logInBtnAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toLogIn", sender: nil)
    }
    
    @IBAction func signUpBtnAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toSignUp", sender: nil)
    }
}
