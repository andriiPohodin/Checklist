import Foundation

class UserSettings {
    static let defaults = UserDefaults.standard
    static let userName = "user"
    static let currentUserUid = "currentUserUid"
    
    static func setUserData(_ name: String, _ uid: String) {
        defaults.setValue(name, forKey: userName)
        defaults.setValue(uid, forKey: currentUserUid)
    }
    
    static func changeUserName(newName: String) {
        defaults.setValue(newName, forKey: userName)
    }
    
    static func removeUserDataAndGoToFirstVC() {
        defaults.removeObject(forKey: userName)
        defaults.removeObject(forKey: currentUserUid)
        Navigation.goToFirstVC()
    }
    
}

