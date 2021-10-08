import Foundation

struct Scenario {
    let mappingSource: MappingSource
    let sections: [Sections]
}

struct Sections {
    let sectionTitle: SectionTitle
    let sectionDescription: SectionDescription
    let sectionContent: [SectionContent]
}

enum SectionTitle: String {
    case inTheBoxSectionTitle = "inTheBoxSectionTitle"
    case quickStartGuideSectionTitle = "quickStartGuideSectionTitle"
    case indoorSectionTitle = "indoorSectionTitle"
    case outdoorSectionTitle = "outdoorSectionTitle"
    case maintenanceSectionTitle = "maintenanceSectionTitle"
}

enum SectionDescription: String {
    case inTheBoxSectionDescription = "inTheBoxSectionDescription"
    case quickStartGuideSectionDescription = "quickStartGuideSectionDescription"
    case indoorSectionDescription = "indoorSectionDescription"
    case outdoorSectionDescription = "outdoorSectionDescription"
    case maintenanceSectionDescription = "maintenanceSectionDescription"
}

enum MappingSource: String {
    case xrtk4 = "xrtk4"
    case xmission = "xmission"
}

enum SectionContent: String {
    //MARK: In The Box
    case xp2020 = "xp2020"
    case b13860s = "b13860s"
    case cm12500 = "cm12500"
    case xrtk = "xrtk"
    case acb1 = "acb1"
    case alr6 = "alr6"
    
    //MARK: Quick Start Guide
    case wechat = "wechat"
    case miniProgram = "miniProgram"
    case xagAgri = "xagAgri"
    case xGeomatics = "xGeomatics"
    case activation = "activation"
    case roleDistribution = "roleDistribution"
    case pairingACB1 = "pairingACB1"
    case pairingMobileStation = "pairingMobileStation"
    case pairingRover = "pairingRover"
    case pairingXP2020 = "pairingXP2020"
    case FAQ = "FAQ"
    
    //MARK: Indoor preparations
    case weatherForecastCheck = "weatherForecastCheck"
    case equipmentSetupCheck = "equipmentSetupCheck"
//    case firmwareCheck = "firmwareCheck"
    
    //MARK: Outdoor preparations
    case setUpMobileStation = "setUpMobileStation"
    case xMissionFlight = "xMissionFlight"
    case field = "field"
    case surveyingRover = "surveyingRover"
    case surveyingXmission = "surveyingXmission"
    case sprayWidthAndSafeDistances = "sprayWidthAndSafeDistances"
    case scissors = "scissors"
    case uploadField = "uploadField"
    case operation = "operation"
    case visualCheck = "visualCheck"
    case battery = "battery"
    case propulsionSystem = "propulsionSystem"
    case sprayingSystem = "sprayingSystem"
    case sprayingSystemCalibration = "sprayingSystemCalibration"
    case flightParameters = "flightParameters"
    case start = "start"
    case rth = "rth"
    case speed = "speed"
    case height = "height"
    case dosage = "dosage"
    case work = "work"
    case fillTank = "fillTank"
    case takeOff = "takeOff"
    
    //MARK: Maintenance
    case endShiftMaintenance = "endShiftMaintenance"
    case scheduledMaintenance = "scheduledMaintenance"
}

enum Indicators: String {
    case disclosure = "disclosureIndicator"
}

struct FAQ {
    let steps: [FAQsteps]
}

enum FAQsteps: String {
    case whatIf = "What if?..."
    case canI = "Can I?..."
    case shouldI = "Should I?..."
}
