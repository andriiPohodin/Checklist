import UIKit

class ProgramPartSelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: Constants.Identifiers.customCell, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: Constants.Identifiers.customCell)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var selectedDrone: Drone?
    var sections = [Sections]()
    var selectedSectionContent = [SectionContent]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.Segues.toContentsTable:
            guard let destinationVC = segue.destination as? ContentsTableViewController else { return }
            destinationVC.content = selectedSectionContent
            destinationVC.selectedDroneName = selectedDrone?.name
        default:
            break
        }
    }
}

extension ProgramPartSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.customCell, for: indexPath) as? MyTableViewCell else { return UITableViewCell() }
        let section = sections[indexPath.row]
        cell.itemLabel.text = "\(indexPath.row+1)."
        cell.titleLabel.text = section.sectionTitle.rawValue.localized
        cell.indicatorImage.image = UIImage(named: Indicators.disclosure.rawValue)
        cell.descriptionLabel.text = section.sectionDescription.rawValue.localized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSection = sections[indexPath.row]
        selectedSectionContent = selectedSection.sectionContent
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: Constants.Segues.toContentsTable, sender: nil)

    }
}


