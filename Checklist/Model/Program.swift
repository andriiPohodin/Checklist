import Foundation

struct Program {
    let mappingSource: MappingSource
    let sections: [Sections]
}

struct Sections {
    let sectionTitle: SectionTitle
    let sectionDescription: SectionDescription
    let sectionContent: [SectionContent]
}

enum SectionTitle: String {
    case quickStartGuideSectionTitle = "quickStartGuideSectionTitle"
    case indoorSectionTitle = "indoorSectionTitle"
    case outdoorSectionTitle = "outdoorSectionTitle"
}

enum SectionDescription: String {
    case quickStartGuideSectionDescription = "quickStartGuideSectionDescription"
    case indoorSectionDescription = "indoorSectionDescription"
    case outdoorSectionDescription = "outdoorSectionDescription"
}

enum MappingSource: String {
    case xrtk4 = "XRTK4"
    case xmission = "XMission"
}

enum SectionContent: String {
    case inTheBox = "inTheBox"
    case softwareInstall = "softwareInstall"
    case hardwareActivation = "hardwareActivation"
    case rolesDistribution = "rolesDistribution"
    case acb1 = "acb1"
    case pairing = "pairing"
    case fields = "fields"
    case operation = "operation"
    case preflightCheck = "preflightCheck"
    case settingMissionParams = "settingMissionParams"
    case launch = "launch"
    case maintenance = "maintenance"
    case FAQ = "FAQ"
    
    case weatherForecastCheck = "weatherForecastCheck"
    case inBoxCheck = "inBoxCheck"
    
    case locateLaunchPoint = "locateLaunchPoint"
    case surveyingXrtk4 = "surveyingXrtk4"
    case surveyingXmission = "surveyingXmission"
    case assemble = "assemble"
    case failsafeCheck = "failsafeCheck"
    case missionPlanning = "missionPlanning"
    case autoTakeOff = "autoTakeOff"
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
