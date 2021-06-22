import Foundation

class Checklist {
    
    var drones: [Drone]
    
    func defineSelectedDrone (at index: Int) -> Drone {
        let index = drones[index]
        return index
    }
    
    func defineSelectedMappingSource (at index: Int, from drone: Drone) -> Program {
        let program = drone.availableMappingSources[index]
        return program
    }
    
    func defineAvailableMappingSources(drone: Drone) -> [String] {
        let drone = drone
        let mappingSources = drone.availableMappingSources
        let mappingSourcesString = mappingSources.map { $0.mappingSource.rawValue.localized }
        return mappingSourcesString
    }
    
    init (drones: [Drone]) {
        self.drones = drones
    }
}
