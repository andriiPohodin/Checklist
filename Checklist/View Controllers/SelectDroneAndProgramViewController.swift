import UIKit
import iOSDropDown

class SelectDroneAndProgramViewController: UIViewController {
    
    @IBOutlet weak var dronesDropDown: DropDown! {
        didSet {
            let dronesList = dataSource.map { $0.model.rawValue }
            dronesDropDown.optionArray = dronesList
            defineAvailableProgramsList()
            
            dronesDropDown.isSearchEnable = false
            dronesDropDown.checkMarkEnabled = false
            dronesDropDown.rowHeight = dronesDropDown.frame.height
            dronesDropDown.listHeight = dronesDropDown.frame.height * CGFloat(dronesDropDown.optionArray.count)
            dronesDropDown.borderWidth = 1
            dronesDropDown.borderColor = .black
            dronesDropDown.cornerRadius = dronesDropDown.frame.height / 2
        }
    }
    @IBOutlet weak var mainImageView: UIImageView! {
        didSet {
            mainImageView.image = UIImage(named: "defaultImage")
        }
    }
    @IBOutlet weak var programsDropDown: DropDown! {
        didSet {
            specifyProgramType()
            
            programsDropDown.isSearchEnable = false
            programsDropDown.checkMarkEnabled = false
            programsDropDown.rowHeight = programsDropDown.frame.height
            programsDropDown.borderWidth = 1
            programsDropDown.borderColor = .black
            programsDropDown.cornerRadius = programsDropDown.frame.height / 2
        }
    }
    @IBOutlet weak var nextBtn: UIButton! {
        didSet {
            nextBtn.setTitle("nextBtn".localized, for: .normal)
        }
    }
    
    var selectedDrone: Drone?
    var selectedProgram: Program?
//    var checklist: Checklist
    let dataSource =
        [Drone(model: .mavic2pro, availablePrograms: [
                Program(type: .basic, software: .djiGo4, description: ([.weatherForecastCheck, .inBoxCheck], [.locateLaunchPoint, .assemble, .homePointCheck, .failsafeCheck, .compassCalibration, .manualTakeOff])),
                Program(type: .advanced, software: .djiGsPro, description: ([.weatherForecastCheck, .missionPlanning, .inBoxCheck], [.locateLaunchPoint, .assemble, .homePointCheck, .failsafeCheck, .compassCalibration, .autoTakeOff])),
                Program(type: .pro, software: .djiGsPro, description: ([.weatherForecastCheck, .nfzCheck, .missionPlanning, .inBoxCheck], [.locateLaunchPoint, .assemble, .homePointCheck, .failsafeCheck, .compassCalibration, .autoTakeOff]))]),
         Drone(model: .phantom4rtk, availablePrograms: [
                Program(type: .advanced, software: .djiGsRtk, description: ([.weatherForecastCheck, .missionPlanning, .inBoxCheck], [.locateLaunchPoint, .assemble, .homePointCheck, .failsafeCheck, .compassCalibration, .autoTakeOff])),
                Program(type: .pro, software: .djiGsRtk, description: ([.weatherForecastCheck, .nfzCheck, .missionPlanning, .inBoxCheck], [.locateLaunchPoint, .assemble, .homePointCheck, .failsafeCheck, .compassCalibration, .autoTakeOff]))]),
         Drone(model: .matrice300rtk, availablePrograms: [
                Program(type: .basic, software: .djiPilot, description: ([.weatherForecastCheck, .inBoxCheck], [.locateLaunchPoint, .assemble, .homePointCheck, .failsafeCheck, .compassCalibration, .manualTakeOff])),
                Program(type: .advanced, software: .djiPilot, description: ([.weatherForecastCheck, .missionPlanning, .inBoxCheck], [.locateLaunchPoint, .assemble, .homePointCheck, .failsafeCheck, .compassCalibration, .autoTakeOff])),
                Program(type: .pro, software: .djiPilot, description: ([.weatherForecastCheck, .nfzCheck, .missionPlanning, .inBoxCheck], [.locateLaunchPoint, .assemble, .homePointCheck, .failsafeCheck, .compassCalibration, .autoTakeOff]))])]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ProgramPartSelection":
            guard let destinationVC = segue.destination as? ProgramPartSelectionViewController else { return }
            destinationVC.specifiedDrone = selectedDrone
            guard let program = selectedProgram else { return }
            destinationVC.specifiedDrone?.availablePrograms = [program]
        default:
            break
        }
    }
    
    func defineAvailableProgramsList() {
        dronesDropDown.didSelect { [weak self] (model, index, _) in
            self?.selectedDrone = self?.dataSource[index]
            guard let availablePrograms = self?.selectedDrone?.availablePrograms else { return }
            let programsList = availablePrograms.map { $0.type.rawValue }
            self?.programsDropDown.optionArray = programsList
            self?.mainImageView.image = UIImage(named: model)
            self?.resetDropDownBorder(dropDown: self!.dronesDropDown)
            self?.resetDropDownText(dropDown: self!.programsDropDown)
            self?.programsDropDown.selectedRowColor = .clear
        }
    }
    
    func specifyProgramType() {
        programsDropDown.didSelect { [weak self] (_, index, _) in
            self?.selectedProgram = self?.selectedDrone?.availablePrograms[index]
            self?.resetDropDownBorder(dropDown: self!.programsDropDown)
            self?.programsDropDown.selectedRowColor = .systemGray4
        }
    }
    
    func resetDropDownText(dropDown: DropDown) {
        dropDown.text = ""
    }
    
    func resetDropDownBorder(dropDown: DropDown) {
        dropDown.borderWidth = 1
        dropDown.borderColor = .black
    }
    
    func markDropDownBorder(dropDown: DropDown) {
        dropDown.borderWidth = 3
        dropDown.borderColor = .systemRed
    }
    
    func validateRequiredInfoInput() {
        if dronesDropDown.text == "" {
            markDropDownBorder(dropDown: dronesDropDown)
            markDropDownBorder(dropDown: programsDropDown)
        }
        if programsDropDown.text == "" {
            markDropDownBorder(dropDown: programsDropDown)
        }
        else {
            resetDropDownBorder(dropDown: dronesDropDown)
            resetDropDownBorder(dropDown: programsDropDown)
            performSegue(withIdentifier: "ProgramPartSelection", sender: nil)
        }
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        validateRequiredInfoInput()
    }
}

