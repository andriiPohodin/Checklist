import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentView: UIView! {
        didSet {
//            contentImageView.image = UIImage(named: "\(index)")
//            contentLabel.text = "\(content[index])"
            contentLabel.text = "\(index + 1)"
        }
    }
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    var index = Int()
    var content = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(content)
    }
}

extension ContentViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
}
