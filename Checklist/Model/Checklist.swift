import Foundation

class Checklist {
    
    var drones: [Drone]
    
    func defineSelectedDrone (at index: Int) -> Drone {
        let index = drones[index]
        return index
    }
    
    func defineSelectedScenario (at index: Int, from drone: Drone) -> Scenario {
        let scenario = drone.availableScenarious[index]
        return scenario
    }
    
    func defineAvailableMappingSources(drone: Drone) -> [String] {
        let drone = drone
        let scenarious = drone.availableScenarious
        let mappingSourcesString = scenarious.map { "\($0.mappingSource)".localized }
        return mappingSourcesString
    }
    
    init (drones: [Drone]) {
        self.drones = drones
    }
}
