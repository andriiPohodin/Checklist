import Foundation

struct Constants {
    static let storageRef = "gs://preflightchecklist-323e2.appspot.com/profile"
    
    struct Storyboard {
        static let main = "Main"
        static let logIn = "LogIn"
    }
    
    struct Segues {
        static let toProgramPartSelection = "toProgramPartSelection"
        static let toStartGuide = "toStartGuide"
        static let toPreparationsContent = "toPreparationsContent"
        static let toStartGuideContent = "toStartGuideContent"
        static let toFAQ = "toFAQ"
        static let toFAQContent = "toFAQContent"
    }
    
    struct Identifiers {
        static let customCell = "MyTableViewCell"
    }
}
