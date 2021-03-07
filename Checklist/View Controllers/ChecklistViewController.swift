import UIKit

class ChecklistViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    var generatedStepNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(generatedStepNames)
    }
}

extension ChecklistViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
}
