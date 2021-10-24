import UIKit
import MessageUI
import SafariServices

class FeedbackFormViewController: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func showMailComposer() {
        if MFMailComposeViewController.canSendMail() {
            let composer = MFMailComposeViewController()
            composer.delegate = self
            composer.setToRecipients(["andrii.pohodin90@gmail.com"])
            composer.setSubject("FAQ feedback")
            present(UINavigationController(rootViewController: composer), animated: true)
        }
        else {
            guard let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfp9-JYT8jfNurddiDoKQp_BW5f64c1TiKn_dcOfLkRHHiQDg/viewform?vc=0&c=0&w=1&flr=0") else { return }
            let safariVc = SFSafariViewController(url: url)
            present(safariVc, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            controller.dismiss(animated: true, completion: nil)
            print(String(describing: error?.localizedDescription))
        }
        else {
            switch result {
            case .cancelled:
                controller.dismiss(animated: true, completion: nil)
            case .failed:
                let alert = UIAlertController(title: "Error", message: "Failed to send message", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "Confirm", style: .default, handler: nil)
                alert.addAction(confirm)
                present(alert, animated: true)
            case .saved:
                controller.dismiss(animated: true, completion: nil)
                print("Message saved to draft")
            case .sent:
                controller.dismiss(animated: true, completion: nil)
                print("Message sent")
            default: break
            }
        }
    }
}
