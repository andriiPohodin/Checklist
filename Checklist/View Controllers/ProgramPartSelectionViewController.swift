import UIKit

class ProgramPartSelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: "MyTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "MyTableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    var specifiedDrone: Drone?
    var generatedStepNames = [String]()
    
    let dataSource = [
        CustomCell(title: .indoor, indicatorName: .disclosure, description: .indoorDescription),
        CustomCell(title: .outdoor, indicatorName: .disclosure, description: .outdoorDescription)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ToChecklist":
            guard let destinationVC = segue.destination as? ChecklistViewController else { return }
            destinationVC.stepNames = generatedStepNames
        default:
            break
        }
    }
}

extension ProgramPartSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell else { return UITableViewCell() }
        let result = dataSource[indexPath.row]
        cell.titleLabel.text = result.title.rawValue
        cell.indicatorImage.image = UIImage(named: result.indicatorName.rawValue)
        cell.descriptionLabel.text = result.description.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let droneModel = specifiedDrone?.model.rawValue else { return }
        guard let program = specifiedDrone?.availablePrograms.first else { return }
        let programType = program.type.rawValue
        let selectedRow = dataSource[indexPath.row]
        switch selectedRow.title {
        case .indoor:
            let steps = program.description.indoor
            for step in steps {
                generatedStepNames.append (programType + program.software.rawValue + droneModel.replacingOccurrences(of: " ", with: "") + step.rawValue)
            }
        case .outdoor:
            let steps = program.description.outdoor
            for step in steps {
                generatedStepNames.append (programType + program.software.rawValue + droneModel.replacingOccurrences(of: " ", with: "") + step.rawValue)
            }
        }
        performSegue(withIdentifier: "ToChecklist", sender: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


