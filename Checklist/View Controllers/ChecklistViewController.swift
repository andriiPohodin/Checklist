import UIKit

class ChecklistViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var contentView: ContentView!
    
    var stepNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(stepNames)
    }
    
}

extension ChecklistViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
}
