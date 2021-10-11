import Foundation

struct Scenario {
    let mappingSource: MappingSource
    let sections: [Section]
}

enum MappingSource {
    case xrtk4
    case xmission
}

struct Section {
//    let inTheBoxSection: (inTheBoxSectionTitle: SectionTitle, inTheBoxSectionDescription: SectionDescription, inTheBoxSectionContent: [InTheBoxSectionContent])
//    let quickStartGuideSection: (quickStartGuideSectionTitle: SectionTitle, quickStartGuideSectionDescription: SectionDescription, quickStartGuideSectionContent: [QuickStartGuideSectionContent])
//    let indoorPreparationsSection: (indoorSectionTitle: SectionTitle, indoorSectionDescription: SectionDescription, indoorPreparationsSectionContent: [IndoorPreparationsSectionContent])
//    let outdoorPreparationsSection: (outdoorSectionTitle: SectionTitle, outdoorSectionDescription: SectionDescription, outdoorPreparationsSectionContent: [OutdoorPreparationsSectionContent])
//    let maintenanceSection: (maintenanceSectionTitle: SectionTitle, maintenanceSectionDescription: SectionDescription, maintenanceSectionContent: [MaintenanceSectionContent])
    let sectionTitle: SectionTitle
    let sectionDescription: SectionDescription
    let sectionContent: [SectionsContent]
}

enum SectionTitle {
    case inTheBoxSectionTitle
    case quickStartGuideSectionTitle
    case indoorSectionTitle
    case outdoorSectionTitle
    case maintenanceSectionTitle
}

enum SectionDescription {
    case inTheBoxSectionDescription
    case quickStartGuideSectionDescription
    case indoorSectionDescription
    case outdoorSectionDescription
    case maintenanceSectionDescription
}

//MARK: In The Box
enum InTheBoxSectionContent: SectionsContent {
    case xp2020
    case b13860s
    case cm12500
    case xrtk
    case acb1
    case alr6
}

//MARK: Quick Start Guide
enum QuickStartGuideSectionContent: SectionsContent {
    case wechat
    case miniProgram
    case xagAgri
    case xGeomatics
    case activation
    case roleDistribution
    case pairingACB1
    case pairingMobileStation
    case pairingRover
    case pairingXP2020
    case FAQ
}

//MARK: Indoor preparations
enum IndoorSectionContent: SectionsContent {
    case weatherForecastCheck
    case equipmentSetupCheck
    case firmwareCheck
}

//MARK: Outdoor preparations
enum OutdoorSectionContent: SectionsContent {
    case setUpMobileStation
    case xMissionFlight
    case field
    case surveyingRover
    case surveyingXmission
    case sprayWidthAndSafeDistances
    case scissors
    case uploadField
    case operation
    case visualCheck
    case battery
    case propulsionSystem
    case sprayingSystem
    case sprayingSystemCalibration
    case flightParameters
    case start
    case rth
    case speed
    case height
    case dosage
    case work
    case fillTank
    case takeOff
}

//MARK: Maintenance
enum MaintenanceSectionContent: String, SectionsContent {
    case endShiftMaintenance
    case scheduledMaintenance
}

struct FAQ {
    let steps: [FAQsteps]
}

enum FAQsteps: String, SectionsContent {
    case whatIf = "What if?..."
    case canI = "Can I?..."
    case shouldI = "Should I?..."
}

protocol SectionsContent {
    
}
