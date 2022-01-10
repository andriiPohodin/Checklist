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
    var sectionsContent = [SectionsContent]()
    private var contentSlideNames = [String]()
    private var contentLabelTextStrings = [String]()
    private var index = Int()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier {
        case Constants.Segues.toProgramStepContent:
            guard let destinationVC = segue.destination as? ContentViewController else { return }
            destinationVC.contentSlideNames = contentSlideNames
            destinationVC.currentSlideIndex = index
            destinationVC.contentLabelTextStrings = contentLabelTextStrings
        case Constants.Segues.toFAQ:
            guard let destinationVC = segue.destination as? FAQViewController else { return }
            destinationVC.selectedFaqStepIndex = index
        default:
            break
        }
    }
    
    private func moveToSlides() {
        guard let selectedDroneNameString = selectedDroneName?.rawValue else { return }
        for step in sectionsContent {
            let stepString = "\(step)"
            contentLabelTextStrings.append(stepString)
            contentSlideNames.append(selectedDroneNameString + stepString)
        }
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            guard let secondaryVC = splitViewController?.viewController(for: .secondary) as? ContentViewController else { return }
            _ = secondaryVC.view
            secondaryVC.contentLabelTextStrings = contentLabelTextStrings
            secondaryVC.contentSlideNames = contentSlideNames
            secondaryVC.currentSlideIndex = index
            secondaryVC.updateUI()
        }
        else {
            performSegue(withIdentifier: Constants.Segues.toProgramStepContent, sender: nil)
        }
    }
}

extension ContentsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.customCell, for: indexPath) as? MyTableViewCell else { return UITableViewCell() }
        let content = sectionsContent[indexPath.row]
        cell.itemLabel.text = "\(indexPath.row+1)."
        cell.titleLabel.text = "\(content)".localized
        cell.descriptionLabel.text = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentSlideNames.removeAll()
        index = indexPath.row
        if let selectedRow = sectionsContent[index] as? QuickStartGuideSectionContent {
            switch selectedRow {
            case .FAQ:
                performSegue(withIdentifier: Constants.Segues.toFAQ, sender: nil)
            default:
                moveToSlides()
            }
        }
        else {
            moveToSlides()
        }
//        tableView.deselectRow(at: indexPath, animated: false)
    }
}
