import UIKit

class Navigation {
    
    static func ifLoggedIn() {
        if UserSettings.userDefaults.value(forKey: UserSettings.userName) != nil {
            goToMainVC()
        }
        else if UserSettings.userDefaults.value(forKey: UserSettings.userName) == nil {
            goToFirstVC()
        }
    }
    
    static func goToMainVC() {
        guard let vc = UIStoryboard(name: Constants.Storyboard.main, bundle: nil).instantiateInitialViewController() else { return }
        UIApplication.shared.windows.first?.rootViewController = vc
    }
    
    static func goToFirstVC() {
        guard let vc = UIStoryboard(name: Constants.Storyboard.logIn, bundle: nil).instantiateInitialViewController() else { return }
        UIApplication.shared.windows.first?.rootViewController = vc
    }
    
}
