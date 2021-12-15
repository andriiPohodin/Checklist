import UIKit

class AppCurrentStateSaver {
    
    static var navigationStack = [UIViewController]()
    
    static func rebuildNavigationHierarchy(svc: UISplitViewController, collapsing: Bool) {
        guard let primaryNavVC = svc.viewController(for: .primary) as? UINavigationController else { return }
        guard let compactNavVC = svc.viewController(for: .compact) as? UINavigationController else { return }
        primaryNavVC.popToRootViewController(animated: false)
        compactNavVC.popToRootViewController(animated: false)
        if !navigationStack.isEmpty {
            navigationStack.removeFirst()
        }
        DispatchQueue.main.async {
            if collapsing {
                for vc in navigationStack {
                    compactNavVC.pushViewController(vc, animated: false)
                }
            }
            else {
                for vc in navigationStack {
                    primaryNavVC.pushViewController(vc, animated: false)
                }
            }
        }
    }
}
