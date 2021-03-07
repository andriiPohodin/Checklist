import Foundation

class Checklist {
    
    var drones: [Drone]
    
    func defineSelectedDrone (at index: Int) -> Drone {
        let index = drones[index]
        return index
    }
    
    func defineSelectedProgram (at index: Int, from drone: Drone) -> Program {
        let program = drone.availablePrograms[index]
        return program
    }
    
    func defineAvailablePrograms(drone: Drone) -> [String] {
        let drone = drone
        let programs = drone.availablePrograms
        let programNames = programs.map { $0.name.rawValue.localized }
        return programNames
    }
    
    init (drones: [Drone]) {
        self.drones = drones
    }
}
