import Foundation

struct Drone {
    let model: Model
    var availablePrograms: [Program]
}

struct Program {
    let type: ProgramType
    let software: Software
    let description: (indoor: [IndoorDescription], outdoor: [OutdoorDescription])
}

enum ProgramType: String {
    case basic = "Basic"
    case advanced = "Advanced"
    case pro = "Pro"
}

enum Model: String {
    case matrice300rtk = "Matrice 300 RTK"
    case phantom4rtk = "Phantom 4 RTK"
    case mavic2pro = "Mavic 2 Pro"
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
