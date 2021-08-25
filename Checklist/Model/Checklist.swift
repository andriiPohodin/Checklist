import Foundation

class Checklist {
    
    var drones: [Drone]
    
    func defineSelectedDrone (at index: Int) -> Drone {
        let index = drones[index]
        return index
    }
    
    func defineSelectedMappingSource (at index: Int, from drone: Drone) -> Scenario {
        let scenario = drone.availableWorkingScenarious[index]
        return scenario
    }
    
    func defineAvailableMappingSources(drone: Drone) -> [String] {
        let drone = drone
        let scenarious = drone.availableWorkingScenarious
        let mappingSourcesString = scenarious.map { $0.mappingSource.rawValue.localized }
        return mappingSourcesString
    }
    
    init (drones: [Drone]) {
        self.drones = drones
    }
}
