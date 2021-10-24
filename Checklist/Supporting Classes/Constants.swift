import Foundation

struct Constants {
    static let storageRef = "gs://xag-manual.appspot.com/profile"
    static let disclosureIndicator = "disclosureIndicator"
    
    struct Storyboard {
        static let main = "Main"
        static let logIn = "LogIn"
    }
    
    struct Segues {
        static let toProgramPartSelection = "toProgramPartSelection"
        static let toContentsTable = "toContentsTable"
        static let toProgramStepContent = "toProgramStepContent"
        static let toFAQ = "toFAQ"
        static let toFAQContent = "toFAQContent"
    }
    
    struct Identifiers {
        static let customCell = "MyTableViewCell"
        static let contactUsCell = "ContactUsTableViewCell"
    }
}
