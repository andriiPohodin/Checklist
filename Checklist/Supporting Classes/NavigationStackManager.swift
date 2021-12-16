import UIKit

class NavigationStackManager {
    
    static var navigationStack = [UIViewController]()
    static var secondaryVC: UIViewController?
    
    static func rebuildNavigationHierarchy(svc: UISplitViewController, collapsing: Bool) {
        if !navigationStack.isEmpty {
            navigationStack.removeFirst()
        }
        guard let primaryNavVC = svc.viewController(for: .primary) as? UINavigationController else { return }
        guard let compactNavVC = svc.viewController(for: .compact) as? UINavigationController else { return }
        if collapsing {
            guard let rootVC = compactNavVC.topViewController as? RootViewController else { return }
            rootVC.didPerformSegueFromRoot = true
            for vc in navigationStack {
                compactNavVC.pushViewController(vc, animated: false)
            }
        }
        else {
            guard let rootVC = primaryNavVC.topViewController as? RootViewController else { return }
            rootVC.didPerformSegueFromRoot = true
            for vc in navigationStack {
                primaryNavVC.pushViewController(vc, animated: false)
            }
        }
    }
    
    static func saveHierarchyFromRegular(svc: UISplitViewController) {
        if let primaryNav = svc.viewController(for: .primary) as? UINavigationController, let compactNav = svc.viewController(for: .compact) as? UINavigationController {
            NavigationStackManager.navigationStack = primaryNav.viewControllers
            primaryNav.popToRootViewController(animated: false)
            compactNav.popToRootViewController(animated: false)
        }
    }
    
    static func saveHierarchyFromCompact(svc: UISplitViewController) {
        if let compactNav = svc.viewController(for: .compact) as? UINavigationController, let primaryNav = svc.viewController(for: .primary) as? UINavigationController {
            NavigationStackManager.navigationStack = compactNav.viewControllers
            compactNav.popToRootViewController(animated: false)
            primaryNav.popToRootViewController(animated: false)
        }
    }
}
