import UIKit

class ContentsTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: Constants.Identifiers.customCell, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: Constants.Identifiers.customCell)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var selectedDroneName: Name?
    var content = [SectionContent]()
    var contentString = [String]()
    var index = Int()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.Segues.toProgramStepContent:
            guard let destinationVC = segue.destination as? ContentViewController else { return }
            destinationVC.content = contentString
            destinationVC.index = index
        case Constants.Segues.toFAQ:
            guard let destinationVC = segue.destination as? FAQViewController else { return }
            let faq = FAQ(steps: [.whatIf, .canI, .shouldI])
            destinationVC.faqSteps = faq.steps
            destinationVC.index = index
        default:
            break
        }
    }
    
}

extension ContentsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.customCell, for: indexPath) as? MyTableViewCell else { return UITableViewCell() }
        let content = content[indexPath.row]
        cell.titleLabel.text = content.rawValue.localized
        cell.descriptionLabel.text = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentString.removeAll()
        index = indexPath.row
        let selectedRow = content[index]
        switch selectedRow {
        case .FAQ:
            performSegue(withIdentifier: Constants.Segues.toFAQ, sender: nil)
        default:
            guard let selectedDroneNameString = selectedDroneName?.rawValue else { return }
            for step in content {
                let stepString = step.rawValue
                contentString.append(selectedDroneNameString + stepString)
            }
            performSegue(withIdentifier: Constants.Segues.toProgramStepContent, sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
