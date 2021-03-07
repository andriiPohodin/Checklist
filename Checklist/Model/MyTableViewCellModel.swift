import Foundation

struct CustomCell {
    let title: Title
    let indicatorName: Indicator
    let description: Description
}

enum Title: String {
    case indoor = "Indoor preparations"
    case outdoor = "Outdoor preparations"
}

enum Indicator: String {
    case disclosure = "Disclosure indicator"
}

enum Description: String {
    case indoorDescription = "Preparations needed to be done before leaving. PC, power outlet and Internet connection required"
    case outdoorDescription = "Preparations needed to be done after arriving on site. No PC, power outlet or Internet connection required"
}
