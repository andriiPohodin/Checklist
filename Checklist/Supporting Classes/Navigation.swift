import UIKit

final class Navigation {
    
    static func ifLoggedIn() {
        if UserSettings.defaults.value(forKey: UserSettings.userName) != nil {
            goToMainVC()
        }
        else if UserSettings.defaults.value(forKey: UserSettings.userName) == nil {
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
    
    static func svcSetUp(window: UIWindow?) {
        guard let window = window else { return }
        if let svc = window.rootViewController as? UISplitViewController {
            svc.preferredDisplayMode = .oneOverSecondary
            switch UIScreen.main.traitCollection.horizontalSizeClass {
            case .regular:
                svc.setViewController(svc.viewController(for: .primary), for: .compact)
            case .compact:
                svc.setViewController(svc.viewController(for: .compact), for: .primary)
            default: break
            }
        }
    }
}
