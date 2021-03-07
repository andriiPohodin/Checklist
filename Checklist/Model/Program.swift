import Foundation

struct Program {
    let name: ProgramName
    let software: Software
    let description: (indoor: [IndoorDescription], outdoor: [OutdoorDescription])
}

enum ProgramName: String {
    case basic = "Basic"
    case advanced = "Advanced"
    case pro = "Pro"
}

enum Software: String {
    case djiGo4 = "DjiGo4"
    case djiGsPro = "DjiGsPro"
    case djiGsRtk = "DjiGsRtk"
    case djiPilot = "DjiPilot"
}

enum IndoorDescription: String, CaseIterable {
    case weatherForecastCheck = "ForecastCheck"
    case missionPlanning = "MissionPlanning"
    case nfzCheck = "NfzCheck"
    case inBoxCheck = "InBoxCheck"
}

enum OutdoorDescription: String, CaseIterable {
    case locateLaunchPoint = "LaunchPoint"
    case assemble = "Assemble"
    case homePointCheck = "HomePointCheck"
    case failsafeCheck = "FailsafeCheck"
    case compassCalibration = "CompassCalibration"
    case autoTakeOff = "AutoTakeOff"
    case manualTakeOff = "ManualTakeOff"
}
