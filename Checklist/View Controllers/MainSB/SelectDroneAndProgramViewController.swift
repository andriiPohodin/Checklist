import UIKit
import iOSDropDown

class SelectDroneAndProgramViewController: UIViewController {
    
    private var lastSeguedVC: UIViewController?
    
    @IBOutlet weak var dronesDropDown: DropDown! {
        didSet {
            defineAvailableDronesAndScenarious()
            setUp(dropDown: dronesDropDown, placeholder: LocalizedKeys.Placeholders.dronesDropDown)
        }
    }
    @IBOutlet weak var mainImageView: UIImageView! {
        didSet {
            mainImageView.image = UIImage(named: LocalizedKeys.ImgNames.mainImageView)
        }
    }
    @IBOutlet weak var scenariousDropDown: DropDown! {
        didSet {
            defineScenarioSections()
            setUp(dropDown: scenariousDropDown, placeholder: LocalizedKeys.Placeholders.mappingSourcesDropDown)
        }
    }
    @IBOutlet weak var nextBtn: UIButton! {
        didSet {
            nextBtn.layer.cornerRadius = nextBtn.frame.height/2
            nextBtn.layer.backgroundColor = UIColor.systemGreen.cgColor
            nextBtn.setTitle(LocalizedKeys.BtnTitles.nextBtn, for: .normal)
        }
    }
    
    var selectedDrone: Drone?
    var selectedScenarioSections: [Section]?
    
    let checklist =
        Checklist(drones: [
                    Drone(name: .xagXp2020, availableScenarious: [
                            Scenario(mappingSource: .xrtk4, sections: [
                                        Section(sectionTitle: .inTheBoxSectionTitle, sectionDescription: .inTheBoxSectionDescription, sectionContent: [InTheBoxSectionContent.xp2020, .b13860s, .cm12500, .xrtk, .acb1, .alr6]),
                                        Section(sectionTitle: .quickStartGuideSectionTitle, sectionDescription: .quickStartGuideSectionDescription, sectionContent: [QuickStartGuideSectionContent.wechat, .miniProgram, .xagAgri, .activation, .roleDistribution, .pairingACB1, .pairingMobileStation, .pairingRover, .pairingXP2020, .FAQ]),
                                        Section(sectionTitle: .indoorSectionTitle, sectionDescription: .indoorSectionDescription, sectionContent: [IndoorSectionContent.weatherForecastCheck, .equipmentSetupCheck]),
                                        Section(sectionTitle: .outdoorSectionTitle, sectionDescription: .outdoorSectionDescription, sectionContent: [OutdoorSectionContent.setUpMobileStation, .field, .surveyingRover, .sprayWidthAndSafeDistances, .scissors, .uploadField, .operation, .visualCheck, .battery, .propulsionSystem, .sprayingSystem, .sprayingSystemCalibration, .flightParameters, .start, .rth, .speed, .height, .dosage, .work, .fillTank, .takeOff]),
                                        Section(sectionTitle: .maintenanceSectionTitle, sectionDescription: .maintenanceSectionDescription, sectionContent: [MaintenanceSectionContent.endShiftMaintenance, .scheduledMaintenance])]),
                            Scenario(mappingSource: .xmission, sections: [
                                        Section(sectionTitle: .inTheBoxSectionTitle, sectionDescription: .inTheBoxSectionDescription, sectionContent: [InTheBoxSectionContent.xp2020, .b13860s, .cm12500, .xrtk, .acb1, .alr6]),
                                        Section(sectionTitle: .quickStartGuideSectionTitle, sectionDescription: .quickStartGuideSectionDescription, sectionContent: [QuickStartGuideSectionContent.wechat, .miniProgram, .xagAgri, .xGeomatics, .activation, .roleDistribution, .pairingACB1, .pairingMobileStation, .pairingXP2020, .FAQ]),
                                        Section(sectionTitle: .indoorSectionTitle, sectionDescription: .indoorSectionDescription, sectionContent: [IndoorSectionContent.weatherForecastCheck, .equipmentSetupCheck]),
                                        Section(sectionTitle: .outdoorSectionTitle, sectionDescription: .outdoorSectionDescription, sectionContent: [OutdoorSectionContent.setUpMobileStation, .xMissionFlight, .field, .surveyingXmission, .sprayWidthAndSafeDistances, .scissors, .uploadField, .operation, .visualCheck, .battery, .propulsionSystem, .sprayingSystem, .sprayingSystemCalibration, .flightParameters, .start, .rth, .speed, .height, .dosage, .work, .fillTank, .takeOff]),
                                        Section(sectionTitle: .maintenanceSectionTitle, sectionDescription: .maintenanceSectionDescription, sectionContent: [MaintenanceSectionContent.endShiftMaintenance, .scheduledMaintenance])])])])
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier {
        case Constants.Segues.toProgramPartSelection:
            guard let destinationVC = segue.destination as? ProgramPartSelectionViewController else { return }
            if selectedDrone != nil, selectedScenarioSections != nil {
                destinationVC.selectedDrone = selectedDrone
                destinationVC.sections = selectedScenarioSections!
            }
        default:
                break
        }
    }
    
    func defineAvailableDronesAndScenarious() {
        let dronesList = checklist.drones.map { $0.name.rawValue.localized }
        dronesDropDown.optionArray = dronesList
        dronesDropDown.didSelect { [weak self] (name, index, _) in
            self?.selectedDrone = self?.checklist.defineSelectedDrone(at: index)
            self?.scenariousDropDown.optionArray = self!.checklist.defineAvailableScenarioNames(drone: self!.selectedDrone!)
            self?.mainImageView.image = UIImage(named: name)
            self?.resetBorder(dropDown: self!.dronesDropDown)
            self?.scenariousDropDown.text = ""
            self?.scenariousDropDown.selectedRowColor = .clear
        }
    }
    
    func defineScenarioSections() {
        scenariousDropDown.didSelect { [weak self] (_, index, _) in
            if self?.selectedDrone != nil {
                self?.selectedScenarioSections = self?.checklist.defineSelectedScenarioSections(scenarioAt: index, from: self!.selectedDrone!)
                self?.resetBorder(dropDown: self!.scenariousDropDown)
                self?.scenariousDropDown.selectedRowColor = .systemGray4
            }
        }
    }
    
    func setUp(dropDown: DropDown, placeholder: String) {
        dropDown.isSearchEnable = false
        dropDown.checkMarkEnabled = false
        dropDown.rowHeight = dropDown.frame.height
        dropDown.borderWidth = 1
        dropDown.borderColor = .black
        dropDown.cornerRadius = dropDown.frame.height / 2
        dropDown.placeholder = placeholder
    }
    
    func resetBorder(dropDown: DropDown) {
        dropDown.borderWidth = 1
        dropDown.borderColor = .black
    }
    
    func markBorder(dropDown: DropDown) {
        dropDown.borderWidth = 3
        dropDown.borderColor = .systemRed
    }
    
    func validateRequiredInfoInput() {
        if dronesDropDown.text == "" {
            markBorder(dropDown: dronesDropDown)
            markBorder(dropDown: scenariousDropDown)
        }
        if scenariousDropDown.text == "" {
            markBorder(dropDown: scenariousDropDown)
        }
        else {
            performSegue(withIdentifier: Constants.Segues.toProgramPartSelection, sender: nil)
        }
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        validateRequiredInfoInput()
    }
}

