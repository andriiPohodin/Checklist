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
    var dataSource = [SectionContent]()
    var content = [String]()
    var index = Int()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.Segues.toProgramStepContent:
            guard let destinationVC = segue.destination as? ContentViewController else { return }
            destinationVC.content = content
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
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.customCell, for: indexPath) as? MyTableViewCell else { return UITableViewCell() }
        let result = dataSource[indexPath.row]
        cell.titleLabel.text = result.rawValue
        cell.descriptionLabel.text = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        content.removeAll()
        index = indexPath.row
        let selectedRow = dataSource[index]
        switch selectedRow {
        case .FAQ:
            performSegue(withIdentifier: Constants.Segues.toFAQ, sender: nil)
        default:
            guard let selectedDroneNameString = selectedDroneName?.rawValue else { return }
            for step in dataSource {
                let stepString = step.rawValue
                content.append(selectedDroneNameString + stepString)
            }
            performSegue(withIdentifier: Constants.Segues.toProgramStepContent, sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
