import UIKit
import PDFKit
import AVKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var previousSlideBtn: UIButton!
    @IBOutlet weak var nextSlideBtn: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundVideoView: UIView!
    
    let pdfView = PDFView()
    var currentSlideIndex = Int()
    var previousSlideIndex = Int()
    var nextSlideIndex = Int()
    var contentSlideNames = [String]()
    var contentLabelTextStrings = [String]()
    var playerLooper: AVPlayerLooper?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SplitViewManager.showMasterInOverlay(splitViewController: splitViewController, viewHeight: view.bounds.height, viewWidth: view.bounds.width)
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            backgroundVideoView.isHidden = false
        }
        else {
            updateUI()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = contentView.bounds
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            playerLooper = VideoManager.play(onSuperview: backgroundVideoView, forResource: "My Movie", ofType: "mp4")
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        SplitViewManager.showMasterInOverlay(splitViewController: splitViewController, viewHeight: size.height, viewWidth: size.width)
    }
    
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            toPreviousSlide()
        case .left:
            toNextSlide()
        default: break
        }
    }
    
    func updateUI() {
        playerLooper = nil
        backgroundVideoView.isHidden = true

        getPdfDocument()
        
        previousSlideBtn.setTitleColor(.systemRed, for: .normal)
        previousSlideIndex = currentSlideIndex-1
        switch currentSlideIndex {
        case contentSlideNames.startIndex:
            previousSlideBtn.isUserInteractionEnabled = false
            previousSlideBtn.setTitle("", for: .normal)
        default:
            previousSlideBtn.isUserInteractionEnabled = true
            previousSlideBtn.setTitle("< " + "\(LocalizedKeys.BtnTitles.previousBtn)", for: .normal)
        }
        
        nextSlideBtn.setTitleColor(.systemRed, for: .normal)
        nextSlideIndex = currentSlideIndex+1
        switch currentSlideIndex {
        case contentSlideNames.endIndex-1:
            nextSlideBtn.isUserInteractionEnabled = false
            nextSlideBtn.setTitle("", for: .normal)
        default:
            nextSlideBtn.isUserInteractionEnabled = true
            nextSlideBtn.setTitle("\(LocalizedKeys.BtnTitles.nextBtn)" + " >", for: .normal)
        }
        
        contentView.addSubview(pdfView)
        
        contentLabel.text = contentLabelTextStrings[currentSlideIndex].localized
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeRight.direction = .right
        pdfView.addGestureRecognizer(swipeLeft)
        pdfView.addGestureRecognizer(swipeRight)
        NavigationStackManager.secondaryVC = self
    }
    
    private func getPdfDocument() {
        guard let url = Bundle.main.url(forResource: contentSlideNames[currentSlideIndex], withExtension: "pdf") else { return }
        guard let pdfDocument = PDFDocument(url: url) else { return }
        pdfView.autoScales = true
        pdfView.goToFirstPage(nil)
        pdfView.document = pdfDocument
    }
    
    private func toNextSlide() {
        if nextSlideIndex == contentSlideNames.endIndex-1 {
            currentSlideIndex+=1
            contentLabel.text = contentLabelTextStrings[currentSlideIndex].localized
            getPdfDocument()
            
            previousSlideIndex+=1
            previousSlideBtn.isUserInteractionEnabled = true
            previousSlideBtn.setTitle("< " + "\(LocalizedKeys.BtnTitles.previousBtn)", for: .normal)
            
            nextSlideIndex+=1
            nextSlideBtn.isUserInteractionEnabled = false
            nextSlideBtn.setTitle("", for: .normal)
        }
        else if nextSlideIndex < contentSlideNames.endIndex {
            currentSlideIndex+=1
            contentLabel.text = contentLabelTextStrings[currentSlideIndex].localized
            getPdfDocument()
            
            previousSlideIndex+=1
            previousSlideBtn.isUserInteractionEnabled = true
            previousSlideBtn.setTitle("< " + "\(LocalizedKeys.BtnTitles.previousBtn)", for: .normal)
            
            nextSlideIndex+=1
            nextSlideBtn.isUserInteractionEnabled = true
            nextSlideBtn.setTitle("\(LocalizedKeys.BtnTitles.nextBtn)" + " >", for: .normal)
        }
    }
    
    private func toPreviousSlide() {
        if previousSlideIndex == contentSlideNames.startIndex {
            currentSlideIndex-=1
            contentLabel.text = contentLabelTextStrings[currentSlideIndex].localized
            getPdfDocument()
            
            nextSlideIndex-=1
            nextSlideBtn.isUserInteractionEnabled = true
            nextSlideBtn.setTitle("\(LocalizedKeys.BtnTitles.nextBtn)" + " >", for: .normal)
            
            previousSlideIndex-=1
            previousSlideBtn.isUserInteractionEnabled = false
            previousSlideBtn.setTitle("", for: .normal)
        }
        else if previousSlideIndex > contentSlideNames.startIndex {
            currentSlideIndex-=1
            contentLabel.text = contentLabelTextStrings[currentSlideIndex].localized
            getPdfDocument()
            
            nextSlideIndex-=1
            nextSlideBtn.isUserInteractionEnabled = true
            nextSlideBtn.setTitle("\(LocalizedKeys.BtnTitles.nextBtn)" + " >", for: .normal)
            
            previousSlideIndex-=1
            previousSlideBtn.isUserInteractionEnabled = true
            previousSlideBtn.setTitle("< " + "\(LocalizedKeys.BtnTitles.previousBtn)", for: .normal)
        }
    }
    
    @IBAction func previousSlideBtnAction(_ sender: UIButton) {
        toPreviousSlide()
    }
    
    @IBAction func nextSlideBtnAction(_ sender: UIButton) {
        toNextSlide()
    }
}
