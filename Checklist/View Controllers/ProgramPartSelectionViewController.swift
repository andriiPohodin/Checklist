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
    var content = [String]()
    
    let dataSource = [
        CustomCell(title: .quickStartGuideTitle, indicatorName: .disclosure, description: .quickStartGuideDescription),
        CustomCell(title: .indoorTitle, indicatorName: .disclosure, description: .indoorDescription),
        CustomCell(title: .outdoorTitle, indicatorName: .disclosure, description: .outdoorDescription)]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.Segues.toPreparationsContent:
            guard let destinationVC = segue.destination as? ContentViewController else { return }
            destinationVC.content = content
            destinationVC.index = content.startIndex
        case Constants.Segues.toStartGuide:
            guard let destinationVC = segue.destination as? StartGuideViewController else { return }
            destinationVC.startGuideSteps = [
                CustomCell(title: .inTheBox, indicatorName: .disclosure, description: .inTheBoxDescription),
                CustomCell(title: .softwareInstall, indicatorName: .disclosure, description: .softwareInstallDescription),
                CustomCell(title: .hardwareActivation, indicatorName: .disclosure, description: .hardwareActivationDescription),
                CustomCell(title: .rolesDistribution, indicatorName: .disclosure, description: .rolesDistributionDescription),
                CustomCell(title: .acb1, indicatorName: .disclosure, description: .acb1Description),
                CustomCell(title: .pairing, indicatorName: .disclosure, description: .pairingDescription),
                CustomCell(title: .fields, indicatorName: .disclosure, description: .fieldsDescription),
                CustomCell(title: .operation, indicatorName: .disclosure, description: .operationDescription),
                CustomCell(title: .preflightCheck, indicatorName: .disclosure, description: .preflightCheckDescription),
                CustomCell(title: .settingMissionParams, indicatorName: .disclosure, description: .settingMissionParamsDescription),
                CustomCell(title: .launch, indicatorName: .disclosure, description: .launchDescription),
                CustomCell(title: .maintenance, indicatorName: .disclosure, description: .maintenanceDescription),
                CustomCell(title: .FAQ, indicatorName: .disclosure, description: .FAQDescription)]
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.customCell, for: indexPath) as? MyTableViewCell else { return UITableViewCell() }
        let result = dataSource[indexPath.row]
        cell.titleLabel.text = result.title.rawValue.localized
        cell.indicatorImage.image = UIImage(named: result.indicatorName.rawValue)
        cell.descriptionLabel.text = result.description.rawValue.localized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        content.removeAll()
        guard let droneModel = selectedDrone?.name.rawValue else { return }
        guard let program = selectedDrone?.availablePrograms.first else { return }
        let programType = program.name.rawValue
        let selectedRow = dataSource[indexPath.row]
        switch selectedRow.title {
        case .quickStartGuideTitle:
            let steps = program.description.quickStartGuide
            for step in steps {
                content.append (programType + program.software.rawValue + droneModel.replacingOccurrences(of: " ", with: "") + step.rawValue)
            }
            performSegue(withIdentifier: Constants.Segues.toStartGuide, sender: nil)
        case .indoorTitle:
            let steps = program.description.indoor
            for step in steps {
                content.append (programType + program.software.rawValue + droneModel.replacingOccurrences(of: " ", with: "") + step.rawValue)
            }
            performSegue(withIdentifier: Constants.Segues.toPreparationsContent, sender: nil)
        case .outdoorTitle:
            let steps = program.description.outdoor
            for step in steps {
                content.append (programType + program.software.rawValue + droneModel.replacingOccurrences(of: " ", with: "") + step.rawValue)
            }
            performSegue(withIdentifier: Constants.Segues.toPreparationsContent, sender: nil)
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


