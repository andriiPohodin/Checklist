import UIKit

class AppCurrentStateSaver {
    
    static var navigationStack = [UIViewController]()
    
    static func rebuiltNavigationHierarchy(svc: UISplitViewController, collapsing: Bool) {
        navigationStack.removeFirst()
        guard let primaryNavVC = svc.viewController(for: .primary) as? UINavigationController else { return }
        guard let compactNavVC = svc.viewController(for: .compact) as? UINavigationController else { return }
        primaryNavVC.popToRootViewController(animated: false)
        compactNavVC.popToRootViewController(animated: false)
        
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
