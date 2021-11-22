import Foundation

struct Checklist {
    
    let drones: [Drone]
    
    func defineSelectedDrone (at index: Int) -> Drone {
        let index = drones[index]
        return index
    }
    
    func defineSelectedScenarioSections (scenarioAt index: Int, from drone: Drone) -> [Section] {
        let scenario = drone.availableScenarious[index]
        let sections = scenario.sections
        return sections
    }
    
    func defineAvailableScenarioNames(drone: Drone) -> [String] {
        let drone = drone
        let scenarious = drone.availableScenarious
        let mappingSourcesString = scenarious.map { "\($0.mappingSource)".localized }
        return mappingSourcesString
    }
}
