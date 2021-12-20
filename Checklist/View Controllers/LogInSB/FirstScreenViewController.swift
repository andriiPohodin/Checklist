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
//        setUpVideo()
        if UIDevice.current.userInterfaceIdiom == .phone, UIScreen.main.traitCollection.horizontalSizeClass == .compact {
            contentView.isHidden = false
            playerLooper = VideoManager.play(onSuperview: contentView, forResource: "My Movie", ofType: "mp4")
        }
        else {
            contentView.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        contentView.isHidden = true
    }
    
    private func setUpVideo() {
        
    }
    
    @IBAction func logInBtnAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toLogIn", sender: nil)
    }
    
    @IBAction func signUpBtnAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toSignUp", sender: nil)
    }
}

extension FirstScreenViewController: SplitViewHierarchyManager {
    
    internal var navigationStack: [UIViewController] {
        get {
            return [UIViewController]()
        }
        set {}
    }
    
    internal func rebuildNavigationHierarchy(in svc: UISplitViewController, from current: UIViewController?, to target: UIViewController?) {
        if let currentNav = current as? UINavigationController, let targetNav = target as? UINavigationController {
            navigationStack = currentNav.viewControllers
            currentNav.popToRootViewController(animated: false)
            if !self.navigationStack.isEmpty {
                self.navigationStack.removeFirst()
            }
            switch currentNav {
            case svc.viewController(for: .primary):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    svc.setViewController(currentNav, for: .compact)
                    for vc in self.navigationStack {
                        targetNav.pushViewController(vc, animated: false)
                    }
                }
            case svc.viewController(for: .compact):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    svc.setViewController(currentNav, for: .primary)
                    for vc in self.navigationStack {
                        targetNav.pushViewController(vc, animated: false)
                    }
                }
            default: break
            }
        }
    }
}

extension FirstScreenViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController,
                             topColumnForCollapsingToProposedTopColumn
                             proposedTopColumn: UISplitViewController.Column)
    -> UISplitViewController.Column {
        rebuildNavigationHierarchy(in: svc, from: svc.viewController(for: .primary), to: svc.viewController(for: .compact))
        return proposedTopColumn
    }

    func splitViewController(_ svc: UISplitViewController,
                             displayModeForExpandingToProposedDisplayMode
                             proposedDisplayMode: UISplitViewController.DisplayMode)
    -> UISplitViewController.DisplayMode {
        rebuildNavigationHierarchy(in: svc, from: svc.viewController(for: .compact), to: svc.viewController(for: .primary))
        return proposedDisplayMode
    }
}
