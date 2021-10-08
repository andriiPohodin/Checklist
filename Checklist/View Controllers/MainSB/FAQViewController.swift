
import UIKit

class FAQViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: Constants.Identifiers.customCell, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: Constants.Identifiers.customCell)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var faqSteps = [FAQsteps]()
    var index = Int()
    var faqStepStrings = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.Segues.toFAQContent:
            guard let destinationVC = segue.destination as? ContentViewController else { return }
            destinationVC.currentSlideIndex = index
            destinationVC.contentImageNames = faqStepStrings
        default:
            break
        }
    }

}

extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqSteps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.customCell, for: indexPath) as? MyTableViewCell else { return UITableViewCell() }
        faqStepStrings.removeAll()
        let faqSteps = faqSteps[indexPath.row]
        cell.itemLabel.text = "\(indexPath.row+1)."
        cell.titleLabel.text = faqSteps.rawValue.localized
        cell.descriptionLabel.text = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        for step in faqSteps {
            let stepString = step.rawValue
            faqStepStrings.append(stepString)
        }
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: Constants.Segues.toFAQContent, sender: nil)
    }
}
