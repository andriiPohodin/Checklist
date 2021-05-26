import UIKit

class StartGuideViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: Constants.Identifiers.customCell, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: Constants.Identifiers.customCell)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var startGuideSteps = [CustomCell]()
    var content = [String]()
    var index = Int()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.Segues.toStartGuideContent:
            guard let destinationVC = segue.destination as? ContentViewController else { return }
            destinationVC.index = index
            destinationVC.content = content
        case Constants.Segues.toFAQ:
            guard let destinationVC = segue.destination as? FAQViewController else { return }
            destinationVC.faqSteps = [
                CustomCell(title: .FAQ, indicatorName: .disclosure, description: .FAQDescription)]
        default:
            break
        }
    }
    
}

extension StartGuideViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return startGuideSteps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.customCell, for: indexPath) as? MyTableViewCell else { return UITableViewCell() }
        let result = startGuideSteps[indexPath.row]
        cell.titleLabel.text = result.title.rawValue.localized
        cell.indicatorImage.image = UIImage(named: result.indicatorName.rawValue)
        cell.descriptionLabel.text = result.description.rawValue.localized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        let selectedRow = startGuideSteps[index]
        let description = startGuideSteps.map { $0.description.rawValue }
        content = description
        tableView.deselectRow(at: indexPath, animated: false)
        switch selectedRow.title {
        case .FAQ:
            performSegue(withIdentifier: Constants.Segues.toFAQ, sender: nil)
        default:
            performSegue(withIdentifier: Constants.Segues.toStartGuideContent, sender: nil)

        }
    }
}
