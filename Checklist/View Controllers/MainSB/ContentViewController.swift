import UIKit
import PDFKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var previousSlideBtn: UIButton!
//        didSet {
//            previousSlideBtn.setTitleColor(.systemRed, for: .normal)
//            previousSlideIndex = currentSlideIndex-1
//            switch currentSlideIndex {
//            case contentSlideNames.startIndex:
//                previousSlideBtn.isUserInteractionEnabled = false
//                previousSlideBtn.setTitle("", for: .normal)
//            default:
//                previousSlideBtn.isUserInteractionEnabled = true
//                previousSlideBtn.setTitle("< " + "\(LocalizedKeys.BtnTitles.previousBtn)", for: .normal)
//            }
//        }
//    }
    @IBOutlet weak var nextSlideBtn: UIButton!
//        didSet {
//            nextSlideBtn.setTitleColor(.systemRed, for: .normal)
//            nextSlideIndex = currentSlideIndex+1
//            switch currentSlideIndex {
//            case contentSlideNames.endIndex-1:
//                nextSlideBtn.isUserInteractionEnabled = false
//                nextSlideBtn.setTitle("", for: .normal)
//            default:
//                nextSlideBtn.isUserInteractionEnabled = true
//                nextSlideBtn.setTitle("\(LocalizedKeys.BtnTitles.nextBtn)" + " >", for: .normal)
//            }
//        }
//    }
    @IBOutlet weak var contentLabel: UILabel!
//        didSet {
//            contentLabel.text = contentSlideNames[currentSlideIndex].localized
//        }
//    }
    @IBOutlet weak var contentView: UIView!
//        didSet {
//            getPdfDocument()
//            contentView.addSubview(pdfView)
//        }
//    }
    
    let pdfView = PDFView()
    var currentSlideIndex = Int()
    var previousSlideIndex = Int()
    var nextSlideIndex = Int()
    var contentSlideNames = [String]()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = contentView.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeRight.direction = .right
        pdfView.addGestureRecognizer(swipeLeft)
        pdfView.addGestureRecognizer(swipeRight)
        print(contentSlideNames)
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
    
    private func getPdfDocument() {
        guard let url = Bundle.main.url(forResource: contentSlideNames[currentSlideIndex], withExtension: "pdf") else { return }
        guard let pdfDocument = PDFDocument(url: url) else { return }
        pdfView.autoScales = true
        pdfView.goToFirstPage(nil)
        pdfView.document = pdfDocument
    }
    
    @IBAction func previousSlideBtnAction(_ sender: UIButton) {
        toPreviousSlide()
    }
    
    @IBAction func nextSlideBtnAction(_ sender: UIButton) {
        toNextSlide()
    }
}
