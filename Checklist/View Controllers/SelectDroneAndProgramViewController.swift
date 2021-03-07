import UIKit
import iOSDropDown

class SelectDroneAndProgramViewController: UIViewController {
    
    @IBOutlet weak var dronesDropDown: DropDown! {
        didSet {
            defineAvailableDronesAndPrograms()
            setUp(dropDown: dronesDropDown, placeholder: "selectDrone")
        }
    }
    @IBOutlet weak var mainImageView: UIImageView! {
        didSet {
            mainImageView.image = UIImage(named: "defaultImage")
        }
    }
    @IBOutlet weak var programsDropDown: DropDown! {
        didSet {
            specifyProgramName()
            setUp(dropDown: programsDropDown, placeholder: "selectProgram")
        }
    }
    @IBOutlet weak var nextBtn: UIButton! {
        didSet {
            nextBtn.setTitle("nextBtnTitle".localized, for: .normal)
        }
    }
    
    var selectedDrone: Drone?
    var selectedProgram: Program?
    
    lazy var checklist =
        Checklist(drones:
                    [Drone(name: .mavic2pro, availablePrograms: [
                            Program(name: .basic, software: .djiGo4, description: ([.weatherForecastCheck, .inBoxCheck], [.locateLaunchPoint, .assemble, .homePointCheck, .failsafeCheck, .compassCalibration, .manualTakeOff])),
                            Program(name: .advanced, software: .djiGsPro, description: ([.weatherForecastCheck, .missionPlanning, .inBoxCheck], [.locateLaunchPoint, .assemble, .homePointCheck, .failsafeCheck, .compassCalibration, .autoTakeOff])),
                            Program(name: .pro, software: .djiGsPro, description: ([.weatherForecastCheck, .nfzCheck, .missionPlanning, .inBoxCheck], [.locateLaunchPoint, .assemble, .homePointCheck, .failsafeCheck, .compassCalibration, .autoTakeOff]))]),
                     Drone(name: .phantom4rtk, availablePrograms: [
                            Program(name: .advanced, software: .djiGsRtk, description: ([.weatherForecastCheck, .missionPlanning, .inBoxCheck], [.locateLaunchPoint, .assemble, .homePointCheck, .failsafeCheck, .compassCalibration, .autoTakeOff])),
                            Program(name: .pro, software: .djiGsRtk, description: ([.weatherForecastCheck, .nfzCheck, .missionPlanning, .inBoxCheck], [.locateLaunchPoint, .assemble, .homePointCheck, .failsafeCheck, .compassCalibration, .autoTakeOff]))]),
                     Drone(name: .matrice300rtk, availablePrograms: [
                            Program(name: .basic, software: .djiPilot, description: ([.weatherForecastCheck, .inBoxCheck], [.locateLaunchPoint, .assemble, .homePointCheck, .failsafeCheck, .compassCalibration, .manualTakeOff])),
                            Program(name: .advanced, software: .djiPilot, description: ([.weatherForecastCheck, .missionPlanning, .inBoxCheck], [.locateLaunchPoint, .assemble, .homePointCheck, .failsafeCheck, .compassCalibration, .autoTakeOff])),
                            Program(name: .pro, software: .djiPilot, description: ([.weatherForecastCheck, .nfzCheck, .missionPlanning, .inBoxCheck], [.locateLaunchPoint, .assemble, .homePointCheck, .failsafeCheck, .compassCalibration, .autoTakeOff]))])])
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ProgramPartSelection":
            guard let destinationVC = segue.destination as? ProgramPartSelectionViewController else { return }
            destinationVC.selectedDrone = selectedDrone
            guard let program = selectedProgram else { return }
            destinationVC.selectedDrone?.availablePrograms = [program]
        default:
            break
        }
    }
    
    func defineAvailableDronesAndPrograms() {
        let dronesList = checklist.drones.map { $0.name.rawValue }
        dronesDropDown.optionArray = dronesList
        dronesDropDown.didSelect { [weak self] (name, index, _) in
            self?.selectedDrone = self?.checklist.defineSelectedDrone(at: index)
            self?.programsDropDown.optionArray = self!.checklist.defineAvailablePrograms(drone: self!.selectedDrone!)
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
        dropDown.placeholder = placeholder.localized
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
            performSegue(withIdentifier: "ProgramPartSelection", sender: nil)
        }
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        validateRequiredInfoInput()
    }
}

