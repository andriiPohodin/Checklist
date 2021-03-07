import Foundation

struct CustomCell {
    let title: Title
    let indicatorName: Indicator
    let description: Description
}

enum Title: String {
    case indoor = "indoorPreparations"
    case outdoor = "outdoorPreparations"
}

enum Indicator: String {
    case disclosure = "Disclosure indicator"
}

enum Description: String {
    case indoorDescription = "indoorDescription"
    case outdoorDescription = "outdoorDescription"
}
