import Foundation

class Checklist {
    
    var drones: [Drone]
    
    func defineSelectedDrone (at index: Int) -> Drone {
        let index = drones[index]
        return index
    }
    
    func defineSelectedScenarioSections (scenarioAt index: Int, from drone: Drone) -> [Section] {
        let scenario = drone.availableScenarious[index]
        let sections = scenario.sections
        return sections
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
