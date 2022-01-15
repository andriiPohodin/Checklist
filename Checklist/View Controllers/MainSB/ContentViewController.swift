import UIKit
import PDFKit
import AVKit

class ContentViewController: UIViewController {
    
    let pdfView = PDFView()
    @IBOutlet weak var previousSlideBtn: UIButton!
    @IBOutlet weak var nextSlideBtn: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundVideoView: UIView!
    
    private var playerLooper: AVPlayerLooper?
    var uiWasUpdated = false
    
    var didTapNext: (() -> Void)?
    var didTapPrevious: (() -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUi()
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular, !uiWasUpdated {
            backgroundVideoView.isHidden = false
        }
        else {
            backgroundVideoView.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = contentView.bounds
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            playerLooper = VideoManager.play(onSuperview: backgroundVideoView, forResource: "My Movie", ofType: "mp4")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        playerLooper = nil
    }
    
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            didTapPrevious?()
        case .left:
            didTapNext?()
        default: break
        }
    }
    
    private func setUpUi() {
        contentView.addSubview(pdfView)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeRight.direction = .right
        pdfView.addGestureRecognizer(swipeLeft)
        pdfView.addGestureRecognizer(swipeRight)
    }
    
    @IBAction func previousSlideBtnAction(_ sender: UIButton) {
        didTapPrevious?()
    }
    
    @IBAction func nextSlideBtnAction(_ sender: UIButton) {
        didTapNext?()
    }
}
