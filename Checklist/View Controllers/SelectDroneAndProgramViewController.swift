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
    @IBOutlet weak var programsDropDown: DropDown! {
        didSet {
            specifyProgramName()
            setUp(dropDown: programsDropDown, placeholder: LocalizedKeys.Placeholders.programsDropDown)
        }
    }
    @IBOutlet weak var nextBtn: UIButton! {
        didSet {
            nextBtn.setTitle(LocalizedKeys.BtnTitles.nextBtn, for: .normal)
        }
    }
    
    var selectedDrone: Drone?
    var selectedProgram: Program?
    
    lazy var checklist =
        Checklist(drones: [Drone(name: .xagXp2020, availablePrograms: [
                                    Program(mappingSource: .xrtk4, sections: [
                                                Sections(sectionTitle: .quickStartGuideSectionTitle, sectionDescription: .quickStartGuideSectionDescription, sectionContent: [.inTheBox, .softwareInstall, .hardwareActivation, .rolesDistribution, .acb1, .pairing, .fields, .operation, .preflightCheck, .settingMissionParams, .launch, .maintenance, .FAQ]),
                                                Sections(sectionTitle: .indoorSectionTitle, sectionDescription: .indoorSectionDescription, sectionContent: [.weatherForecastCheck, .inBoxCheck]),
                                                Sections(sectionTitle: .outdoorSectionTitle, sectionDescription: .outdoorSectionDescription, sectionContent: [.locateLaunchPoint, .surveyingXrtk4, .assemble, .failsafeCheck, .missionPlanning, .autoTakeOff])]),
                                    Program(mappingSource: .xmission, sections: [
                                                Sections(sectionTitle: .quickStartGuideSectionTitle, sectionDescription: .quickStartGuideSectionDescription, sectionContent: [.inTheBox, .softwareInstall, .hardwareActivation, .rolesDistribution, .acb1, .pairing, .fields, .operation, .preflightCheck, .settingMissionParams, .launch, .maintenance, .FAQ]),
                                                Sections(sectionTitle: .indoorSectionTitle, sectionDescription: .indoorSectionDescription, sectionContent: [.weatherForecastCheck, .inBoxCheck]),
                                                Sections(sectionTitle: .outdoorSectionTitle, sectionDescription: .outdoorSectionDescription, sectionContent: [.locateLaunchPoint, .surveyingXmission, .assemble, .failsafeCheck, .missionPlanning, .autoTakeOff])])])])
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.Segues.toProgramPartSelection:
            guard let destinationVC = segue.destination as? ProgramPartSelectionViewController else { return }
            destinationVC.selectedDrone = selectedDrone
            guard let program = selectedProgram else { return }
            destinationVC.selectedDrone?.availablePrograms = [program]
            destinationVC.dataSource = program.sections
        default:
                break
        }
    }
    
    func defineAvailableDronesAndMappingSources() {
        let dronesList = checklist.drones.map { $0.name.rawValue }
        dronesDropDown.optionArray = dronesList
        dronesDropDown.didSelect { [weak self] (name, index, _) in
            self?.selectedDrone = self?.checklist.defineSelectedDrone(at: index)
            self?.programsDropDown.optionArray = self!.checklist.defineAvailableMappingSources(drone: self!.selectedDrone!)
            self?.mainImageView.image = UIImage(named: name)
            self?.resetBorder(dropDown: self!.dronesDropDown)
            self?.programsDropDown.text = ""
            self?.programsDropDown.selectedRowColor = .clear
        }
    }
    
    func specifyProgramName() {
        programsDropDown.didSelect { [weak self] (_, index, _) in
            if self?.selectedDrone != nil {
                self?.selectedProgram = self?.checklist.defineSelectedProgram(at: index, from: self!.selectedDrone!)
                self?.resetBorder(dropDown: self!.programsDropDown)
                self?.programsDropDown.selectedRowColor = .systemGray4
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
            markBorder(dropDown: programsDropDown)
        }
        if programsDropDown.text == "" {
            markBorder(dropDown: programsDropDown)
        }
        else {
            performSegue(withIdentifier: Constants.Segues.toProgramPartSelection, sender: nil)
        }
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        validateRequiredInfoInput()
    }
}

