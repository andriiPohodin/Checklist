import UIKit
import iOSDropDown

class SelectDroneAndProgramViewController: UIViewController {
    
    @IBOutlet weak var dronesDropDown: DropDown! {
        didSet {
            defineAvailableDronesAndMappingSources()
            setUp(dropDown: dronesDropDown, placeholder: LocalizedKeys.Placeholders.dronesDropDown)
        }
    }
    @IBOutlet weak var mainImageView: UIImageView! {
        didSet {
            mainImageView.image = UIImage(named: LocalizedKeys.ImgNames.mainImageView)
        }
    }
    @IBOutlet weak var mappingSourcesDropDown: DropDown! {
        didSet {
//            mappingSourcesDropDown.isUserInteractionEnabled = false
            specifyMappingSourceName()
            setUp(dropDown: mappingSourcesDropDown, placeholder: LocalizedKeys.Placeholders.mappingSourcesDropDown)
        }
    }
    @IBOutlet weak var nextBtn: UIButton! {
        didSet {
            nextBtn.setTitle(LocalizedKeys.BtnTitles.nextBtn, for: .normal)
        }
    }
    
    var selectedDrone: Drone?
    var selectedMappingSource: Scenario?
    
    lazy var checklist =
        Checklist(drones: [
                    Drone(name: .xagXp2020, availableWorkingScenarious: [
                            Scenario(mappingSource: .xrtk4, sections: [
                                        Sections(sectionTitle: .inTheBoxSectionTitle, sectionDescription: .inTheBoxSectionDescription, sectionContent: [.xp2020, .b13860s, .cm12500, .xrtk, .acb1, .alr6]),
                                        Sections(sectionTitle: .quickStartGuideSectionTitle, sectionDescription: .quickStartGuideSectionDescription, sectionContent: [.wechat, .miniProgram, .xagAgri, .activation, .roleDistribution, .pairingACB1, .pairingMobileStation, .pairingRover, .pairingXP2020, .FAQ]),
                                        Sections(sectionTitle: .indoorSectionTitle, sectionDescription: .indoorSectionDescription, sectionContent: [.weatherForecastCheck, .equipmentSetupCheck, .firmwareCheck]),
                                        Sections(sectionTitle: .outdoorSectionTitle, sectionDescription: .outdoorSectionDescription, sectionContent: [.setUpMobileStation, .field, .surveyingRover, .sprayWidthAndSafeDistances, .scissors, .uploadField, .operation, .visualCheck, .battery, .propulsionSystem, .sprayingSystem, .sprayingSystemCalibration, .flightParameters, .start, .rth, .speed, .height, .dosage, .work, .fillTank, .takeOff]),
                                        Sections(sectionTitle: .maintenanceSectionTitle, sectionDescription: .maintenanceSectionDescription, sectionContent: [.endShiftMaintenance, .scheduledMaintenance])]),
                            Scenario(mappingSource: .xmission, sections: [
                                        Sections(sectionTitle: .inTheBoxSectionTitle, sectionDescription: .inTheBoxSectionDescription, sectionContent: [.xp2020, .b13860s, .cm12500, .xrtk, .acb1, .alr6]),
                                        Sections(sectionTitle: .quickStartGuideSectionTitle, sectionDescription: .quickStartGuideSectionDescription, sectionContent: [.wechat, .miniProgram, .xagAgri, .xGeomatics, .activation, .roleDistribution, .pairingACB1, .pairingMobileStation, .pairingXP2020, .FAQ]),
                                        Sections(sectionTitle: .indoorSectionTitle, sectionDescription: .indoorSectionDescription, sectionContent: [.weatherForecastCheck, .equipmentSetupCheck, .firmwareCheck]),
                                        Sections(sectionTitle: .outdoorSectionTitle, sectionDescription: .outdoorSectionDescription, sectionContent: [.setUpMobileStation, .xMissionFlight, .field, .surveyingXmission, .sprayWidthAndSafeDistances, .scissors, .uploadField, .operation, .visualCheck, .battery, .propulsionSystem, .sprayingSystem, .sprayingSystemCalibration, .flightParameters, .start, .rth, .speed, .height, .dosage, .work, .fillTank, .takeOff]),
                                        Sections(sectionTitle: .maintenanceSectionTitle, sectionDescription: .maintenanceSectionDescription, sectionContent: [.endShiftMaintenance, .scheduledMaintenance])])])])
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.Segues.toProgramPartSelection:
            guard let destinationVC = segue.destination as? ProgramPartSelectionViewController else { return }
            destinationVC.selectedDrone = selectedDrone
            guard let mappingSource = selectedMappingSource else { return }
            destinationVC.selectedDrone?.availableWorkingScenarious = [mappingSource]
            destinationVC.sections = mappingSource.sections
        default:
                break
        }
    }
    
    func defineAvailableDronesAndMappingSources() {
        let dronesList = checklist.drones.map { $0.name.rawValue.localized }
        dronesDropDown.optionArray = dronesList
        dronesDropDown.didSelect { [weak self] (name, index, _) in
            self?.selectedDrone = self?.checklist.defineSelectedDrone(at: index)
//            self?.mappingSourcesDropDown.isUserInteractionEnabled = true
            self?.mappingSourcesDropDown.optionArray = self!.checklist.defineAvailableMappingSources(drone: self!.selectedDrone!)
            self?.mainImageView.image = UIImage(named: name)
            self?.resetBorder(dropDown: self!.dronesDropDown)
            self?.mappingSourcesDropDown.text = ""
            self?.mappingSourcesDropDown.selectedRowColor = .clear
        }
    }
    
    func specifyMappingSourceName() {
        mappingSourcesDropDown.didSelect { [weak self] (_, index, _) in
            if self?.selectedDrone != nil {
                self?.selectedMappingSource = self?.checklist.defineSelectedMappingSource(at: index, from: self!.selectedDrone!)
                self?.resetBorder(dropDown: self!.mappingSourcesDropDown)
                self?.mappingSourcesDropDown.selectedRowColor = .systemGray4
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
            markBorder(dropDown: mappingSourcesDropDown)
        }
        if mappingSourcesDropDown.text == "" {
            markBorder(dropDown: mappingSourcesDropDown)
        }
        else {
            performSegue(withIdentifier: Constants.Segues.toProgramPartSelection, sender: nil)
        }
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        validateRequiredInfoInput()
    }
}

