import UIKit
import AVKit

class FirstScreenViewController: UIViewController {
    
    private var playerLooper: AVPlayerLooper?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var logInBtn: UIButton! {
        didSet {
            logInBtn.layer.cornerRadius = CGFloat(logInBtn.frame.height/2)
            logInBtn.layer.backgroundColor = UIColor.systemGreen.cgColor
            logInBtn.setTitleColor(.white, for: .normal)
            logInBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            logInBtn.setTitle("logIn".localized, for: .normal)
        }
    }
    @IBOutlet weak var signUpBtn: UIButton! {
        didSet {
            signUpBtn.layer.cornerRadius = CGFloat(signUpBtn.frame.height/2)
            signUpBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            signUpBtn.setTitle("signUp".localized, for: .normal)
            signUpBtn.setTitleColor(.systemRed, for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpUI()
    }
    
    private func setUpUI() {
        if UIDevice.current.userInterfaceIdiom == .phone, UIScreen.main.traitCollection.horizontalSizeClass == .compact {
            contentView.isHidden = false
            playerLooper = VideoManager.play(onSuperview: contentView, forResource: "My Movie", ofType: "mp4")
        }
        else {
            view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            contentView.isHidden = true
        }
    }
    
    @IBAction func logInBtnAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toLogIn", sender: nil)
    }
    
    @IBAction func signUpBtnAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toSignUp", sender: nil)
    }
}
