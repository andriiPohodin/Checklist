import UIKit
import AVKit

class FirstScreenViewController: UIViewController {
    
    var playerLooper: AVPlayerLooper?

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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerLooper = nil
    }
    
    func setUpVideo() {
        if UIDevice.current.userInterfaceIdiom == .phone, UIScreen.main.traitCollection.horizontalSizeClass == .compact {
            contentView.isHidden = false
            playerLooper = VideoManager.play(onSuperview: contentView, forResource: "My Movie", ofType: "mp4")
        }
        else {
            contentView.isHidden = true
        }
    }
    
    @IBAction func logInBtnAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toLogIn", sender: nil)
    }
    
    @IBAction func signUpBtnAction(_ sender: UIButton) {
//        performSegue(withIdentifier: "toSignUp", sender: nil)
        print("Horizontal " + "\(UIScreen.main.traitCollection.horizontalSizeClass.rawValue)")
        print("Vertical " + "\(UIScreen.main.traitCollection.verticalSizeClass.rawValue)")
        print(UIDevice.current.orientation.rawValue)
    }
}
