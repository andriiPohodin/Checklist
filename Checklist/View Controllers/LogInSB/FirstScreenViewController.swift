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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
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
        performSegue(withIdentifier: "toSignUp", sender: nil)
    }
}

extension FirstScreenViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController,
                             topColumnForCollapsingToProposedTopColumn
                             proposedTopColumn: UISplitViewController.Column)
    -> UISplitViewController.Column {
        if let primaryNav = splitViewController?.viewController(for: .primary) as? UINavigationController {
            AppCurrentStateSaver.navigationStack = primaryNav.viewControllers
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            AppCurrentStateSaver.rebuildNavigationHierarchy(svc: svc, collapsing: true)
        }
        return proposedTopColumn
    }
    func splitViewController(_ svc: UISplitViewController,
                             displayModeForExpandingToProposedDisplayMode
                             proposedDisplayMode: UISplitViewController.DisplayMode)
    -> UISplitViewController.DisplayMode {
        if let compactNav = splitViewController?.viewController(for: .compact) as? UINavigationController {
            AppCurrentStateSaver.navigationStack = compactNav.viewControllers
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            AppCurrentStateSaver.rebuildNavigationHierarchy(svc: svc, collapsing: false)
        }
        return proposedDisplayMode
    }
}
