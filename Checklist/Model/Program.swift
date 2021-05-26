import Foundation

struct Program {
    let name: ProgramName
    let software: Software
    let description: (quickStartGuide: [QuickStartGuide], indoor: [IndoorDescription], outdoor: [OutdoorDescription])
}

enum ProgramName: String {
    case basic = "Basic"
    case advanced = "Advanced"
    case pro = "Pro"
    case xrtk4 = "XRTK4"
    case xmission = "XMission"
}

enum Software: String {
    case djiGo4 = "DjiGo4"
    case djiGsPro = "DjiGsPro"
    case djiGsRtk = "DjiGsRtk"
    case djiPilot = "DjiPilot"
    case xagAgri = "XagAgri"
}

enum QuickStartGuide: String {
    case quickStartGuide = "QuickStartGuide"
}

enum IndoorDescription: String {
    case weatherForecastCheck = "ForecastCheck"
    case missionPlanning = "MissionPlanning"
    case nfzCheck = "NfzCheck"
    case inBoxCheck = "InBoxCheck"
}

enum OutdoorDescription: String {
    case locateLaunchPoint = "LaunchPoint"
    case assemble = "Assemble"
    case homePointCheck = "HomePointCheck"
    case failsafeCheck = "FailsafeCheck"
    case compassCalibration = "CompassCalibration"
    case autoTakeOff = "AutoTakeOff"
    case manualTakeOff = "ManualTakeOff"
    case surveying = "Surveying"
}
