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
    var playerLooper: AVPlayerLooper?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            backgroundVideoView.isHidden = false
        }
        else {
            updateUI()
        }
        print(contentSlideNames)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = contentView.bounds
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            guard let bundlePath = Bundle.main.path(forResource: "My Movie", ofType: "mp4") else { return }
            let url = URL(fileURLWithPath: bundlePath)
            let item = AVPlayerItem(url: url)
            let player = AVQueuePlayer(playerItem: item)
            let layer = AVPlayerLayer(player: player)
            layer.frame = backgroundVideoView.bounds
            layer.videoGravity = .resizeAspectFill
            backgroundVideoView.layer.addSublayer(layer)
            playerLooper = AVPlayerLooper(player: player, templateItem: item)
            player.playImmediately(atRate: 2)
        }
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
        
        contentLabel.text = contentSlideNames[currentSlideIndex].localized
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeRight.direction = .right
        pdfView.addGestureRecognizer(swipeLeft)
        pdfView.addGestureRecognizer(swipeRight)
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
            contentLabel.text = contentSlideNames[currentSlideIndex].localized
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
            contentLabel.text = contentSlideNames[currentSlideIndex].localized
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
            contentLabel.text = contentSlideNames[currentSlideIndex].localized
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
            contentLabel.text = contentSlideNames[currentSlideIndex].localized
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
