import Foundation

struct CustomCell {
    let title: Title
    let indicatorName: Indicator
    let description: Description
}

enum Title: String {
    case quickStartGuideTitle = "quickStartGuideTitle"
    case indoorTitle = "indoorTitle"
    case outdoorTitle = "outdoorTitle"
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
}

enum Indicator: String {
    case disclosure = "disclosureIndicator"
}

enum Description: String {
    case quickStartGuideDescription = "quickStartGuideDescription"
    case indoorDescription = "indoorDescription"
    case outdoorDescription = "outdoorDescription"
    case inTheBoxDescription = "inTheBoxDescription"
    case softwareInstallDescription = "softwareInstallDescription"
    case hardwareActivationDescription = "hardwareActivationDescription"
    case rolesDistributionDescription = "rolesDistributionDescription"
    case acb1Description = "acb1Description"
    case pairingDescription = "pairingDescription"
    case fieldsDescription = "fieldsDescription"
    case operationDescription = "operationDescription"
    case preflightCheckDescription = "preflightCheckDescription"
    case settingMissionParamsDescription = "settingMissionParamsDescription"
    case launchDescription = "launchDescription"
    case maintenanceDescription = "maintenanceDescription"
    case FAQDescription = "FAQDescription"
}
