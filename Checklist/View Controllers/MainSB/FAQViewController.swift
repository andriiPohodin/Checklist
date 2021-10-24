import MessageUI
import SafariServices
import UIKit

class FAQViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: Constants.Identifiers.customCell, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: Constants.Identifiers.customCell)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var contacUsLabel: UILabel! {
        didSet {
            contacUsLabel.text = "Didn't find the answer?"
//            contacUsLabel.isHidden = true
        }
    }
    @IBOutlet weak var contactUsBtn: UIButton! {
        didSet {

            contactUsBtn.layer.cornerRadius = contactUsBtn.frame.height/2
            contactUsBtn.setTitle("Contact us!", for: .normal)
//            contactUsBtn.isHidden = true
        }
    }
//    @IBOutlet weak var contactUsLabelHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var contactUsBtnHeightConstraint: NSLayoutConstraint!
    let faq = FAQ(steps: [.whatIf, .canI, .shouldI, .whatIf, .canI, .shouldI, .whatIf, .canI, .shouldI, .whatIf, .canI, .shouldI, .whatIf, .canI, .shouldI, .whatIf, .canI, .shouldI, .whatIf, .canI, .shouldI, .whatIf, .canI, .shouldI])
    var index = Int()
    var faqStepStringsArray = [String]()
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.Segues.toFAQContent:
            guard let destinationVC = segue.destination as? ContentViewController else { return }
            destinationVC.currentSlideIndex = index
            destinationVC.contentSlideNames = faqStepStringsArray
        default:
            break
        }
    }
    
    func makeUIViewVisible() {
        contactUsBtn.isUserInteractionEnabled = true
        contactUsBtn.setTitleColor(.white, for: .normal)
        contactUsBtn.backgroundColor = .red
        contacUsLabel.textColor = .black
    }

    
    func makeUIViewInvisible() {
        contactUsBtn.isUserInteractionEnabled = false
        contactUsBtn.setTitleColor(.clear, for: .normal)
        contactUsBtn.backgroundColor = .clear
        contacUsLabel.textColor = .clear
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
    
    @IBAction func contactUsBtnAction(_ sender: UIButton) {
        showMailComposer()
    }
}

extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faq.steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.customCell, for: indexPath) as? MyTableViewCell else { return UITableViewCell() }
        faqStepStringsArray.removeAll()
        let faqStep = faq.steps[indexPath.row]
        cell.itemLabel.text = "\(indexPath.row+1)."
        cell.titleLabel.text = "\(faqStep)".localized
        cell.descriptionLabel.text = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        for step in faq.steps {
            let stepString = "\(step)".localized
            faqStepStringsArray.append(stepString)
        }
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: Constants.Segues.toFAQContent, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == faq.steps.count-1 {
            makeUIViewVisible()
//            contacUsLabel.isHidden = false
//            contactUsBtn.isHidden = false
            print("Will display")
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == faq.steps.count-1 {
            makeUIViewInvisible()
//            contacUsLabel.isHidden = true
//            contactUsBtn.isHidden = true
            print("Did end displaying")
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
