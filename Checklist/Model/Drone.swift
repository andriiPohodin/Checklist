import Foundation

struct Drone {
    let name: Name
    var availablePrograms: [Program]
}

enum Name: String {
    case matrice300rtk = "Matrice 300 RTK"
    case phantom4rtk = "Phantom 4 RTK"
    case mavic2pro = "Mavic 2 Pro"
}
