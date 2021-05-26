
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
    
    var faqSteps = [CustomCell]()
    var content = [String]()
    var index = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.Segues.toFAQContent:
            guard let destinationVC = segue.destination as? ContentViewController else { return }
            destinationVC.content = content
            destinationVC.index = index
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
        let result = faqSteps[indexPath.row]
        cell.titleLabel.text = result.title.rawValue.localized
        cell.indicatorImage.image = UIImage(named: result.indicatorName.rawValue)
        cell.descriptionLabel.text = result.description.rawValue.localized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        let title = faqSteps.map { $0.title.rawValue }
        content = title
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
