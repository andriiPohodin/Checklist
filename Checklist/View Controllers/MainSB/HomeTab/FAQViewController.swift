import MessageUI
import SafariServices
import UIKit

class FAQViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let customNib = UINib(nibName: Constants.Identifiers.customCell, bundle: nil)
            tableView.register(customNib, forCellReuseIdentifier: Constants.Identifiers.customCell)
            let contactUsNib = UINib(nibName: Constants.Identifiers.contactUsCell, bundle: nil)
            tableView.register(contactUsNib, forCellReuseIdentifier: Constants.Identifiers.contactUsCell)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    let faq = FAQ(steps: [.whatIf, .canI, .shouldI, .whatIf, .canI, .shouldI, .whatIf, .canI, .shouldI, .whatIf, .canI, .shouldI, .whatIf, .canI, .shouldI, .whatIf, .canI, .shouldI, .whatIf, .canI, .shouldI, .whatIf, .canI, .shouldI, .contactUs])
    var selectedFaqStepIndex = Int()
    private var faqStepStringsArray = [String]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier {
        case Constants.Segues.toFAQContent:
            guard let destinationVC = segue.destination as? ContentViewController else { return }
//            destinationVC.currentSlideIndex = selectedFaqStepIndex
//            destinationVC.contentSlideNames = faqStepStringsArray
//            destinationVC.contentLabelTextStrings = faqStepStringsArray
        default:
            break
        }
    }
    
    private func showMailComposer() {
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
    
    @objc func didTapContactUsBtn() {
        showMailComposer()
    }
}

extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faq.steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        faqStepStringsArray.removeAll()
        let faqStep = faq.steps[indexPath.row]
        switch faqStep {
        case .contactUs:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.contactUsCell, for: indexPath) as? ContactUsTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.contactUsLabel.text = "Didn't find an answer?"
            cell.contactUsBtn.setTitle("Contact Us", for: .normal)
            cell.contactUsBtn.backgroundColor = .systemRed
            cell.contactUsBtn.setTitleColor(.black, for: .normal)
            cell.contactUsBtn.layer.cornerRadius = cell.contactUsBtn.frame.height/2
            cell.contactUsBtn.addTarget(self, action: #selector(didTapContactUsBtn), for: .touchUpInside)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.customCell, for: indexPath) as? MyTableViewCell else { return UITableViewCell() }
            cell.itemLabel.text = "\(indexPath.row+1)."
            cell.titleLabel.text = "\(faqStep)".localized
            cell.descriptionLabel.text = nil
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFaqStep = faq.steps[indexPath.row]
        if selectedFaqStep != .contactUs {
            selectedFaqStepIndex = indexPath.row
            for step in faq.steps {
                if step != .contactUs {
                    let stepString = "\(step)".localized
                    faqStepStringsArray.append(stepString)
                }
            }
//            tableView.deselectRow(at: indexPath, animated: false)
            if (splitViewController?.viewControllers.count)! > 1 {
                guard let secondaryVC = splitViewController?.viewController(for: .secondary) as? ContentViewController else { return }
//                secondaryVC.currentSlideIndex = selectedFaqStepIndex
//                secondaryVC.contentSlideNames = faqStepStringsArray
//                secondaryVC.updateUI()
            }
            else {
                performSegue(withIdentifier: Constants.Segues.toFAQContent, sender: nil)
            }
        }
    }
}

extension FAQViewController: MFMailComposeViewControllerDelegate {
    
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
