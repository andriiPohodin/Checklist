import UIKit
import PDFKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var previousSlideBtn: UIButton! {
        didSet {
            previousSlideBtn.setTitleColor(.systemRed, for: .normal)
            previousSlideIndex = currentSlideIndex-1
            switch currentSlideIndex {
            case contentImageNames.startIndex:
                previousSlideBtn.isUserInteractionEnabled = false
                previousSlideBtn.setTitle("", for: .normal)
            default:
                previousSlideBtn.isUserInteractionEnabled = true
                previousSlideBtn.setTitle("< " + "\(LocalizedKeys.BtnTitles.previousBtn)", for: .normal)
            }
        }
    }
    @IBOutlet weak var nextSlideBtn: UIButton! {
        didSet {
            nextSlideBtn.setTitleColor(.systemRed, for: .normal)
            nextSlideIndex = currentSlideIndex+1
            switch currentSlideIndex {
            case contentImageNames.endIndex-1:
                nextSlideBtn.isUserInteractionEnabled = false
                nextSlideBtn.setTitle("", for: .normal)
            default:
                nextSlideBtn.isUserInteractionEnabled = true
                nextSlideBtn.setTitle("\(LocalizedKeys.BtnTitles.nextBtn)" + " >", for: .normal)
            }
        }
    }
    @IBOutlet weak var contentLabel: UILabel! {
        didSet {
            contentLabel.text = contentImageNames[currentSlideIndex].localized
        }
    }
    @IBOutlet weak var contentView: UIView! {
        didSet {
            pdfView.frame = contentView.bounds
            contentView.addSubview(pdfView)
        }
    }
    
    let pdfView = PDFView()
    var currentSlideIndex = Int()
    var previousSlideIndex = Int()
    var nextSlideIndex = Int()
    var contentImageNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(contentImageNames)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPdfDocument()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeRight.direction = .right
        pdfView.addGestureRecognizer(swipeLeft)
        pdfView.addGestureRecognizer(swipeRight)
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
        
        if nextSlideIndex == contentImageNames.endIndex-1 {
            currentSlideIndex+=1
            contentLabel.text = contentImageNames[currentSlideIndex].localized
            getPdfDocument()
            
            previousSlideIndex+=1
            previousSlideBtn.isUserInteractionEnabled = true
            previousSlideBtn.setTitle("< " + "\(LocalizedKeys.BtnTitles.previousBtn)", for: .normal)
            
            nextSlideIndex+=1
            nextSlideBtn.isUserInteractionEnabled = false
            nextSlideBtn.setTitle("", for: .normal)
        }
        else if nextSlideIndex < contentImageNames.endIndex {
            currentSlideIndex+=1
            contentLabel.text = contentImageNames[currentSlideIndex].localized
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
        
        if previousSlideIndex == contentImageNames.startIndex {
            currentSlideIndex-=1
            contentLabel.text = contentImageNames[currentSlideIndex].localized
            getPdfDocument()
            
            nextSlideIndex-=1
            nextSlideBtn.isUserInteractionEnabled = true
            nextSlideBtn.setTitle("\(LocalizedKeys.BtnTitles.nextBtn)" + " >", for: .normal)
            
            previousSlideIndex-=1
            previousSlideBtn.isUserInteractionEnabled = false
            previousSlideBtn.setTitle("", for: .normal)
        }
        else if previousSlideIndex > contentImageNames.startIndex {
            currentSlideIndex-=1
            contentLabel.text = contentImageNames[currentSlideIndex].localized
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
        guard let url = Bundle.main.url(forResource: contentImageNames[currentSlideIndex], withExtension: "pdf") else { return }
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
