import Foundation

struct Drone {
    let name: Name
    var availableMappingSources: [Program]
}

enum Name: String {
    case xagXp2020 = "XP2020"
}
