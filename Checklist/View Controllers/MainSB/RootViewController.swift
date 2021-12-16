import UIKit

class RootViewController: UIViewController {
            
    var didPerformSegueFromRoot = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
//        if !SelectDroneAndProgramViewController.didPerformedSegueFromRoot {
//            SelectDroneAndProgramViewController.didPerformedSegueFromRoot = true
//            performSegue(withIdentifier: "toTabBar", sender: self)
//        }
        if didPerformSegueFromRoot != true {
            performSegue(withIdentifier: "toTabBar", sender: self)
        }
    }
}

extension RootViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController,
                             topColumnForCollapsingToProposedTopColumn
                             proposedTopColumn: UISplitViewController.Column)
    -> UISplitViewController.Column {
        NavigationStackManager.saveHierarchyFromRegular(svc: svc)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            NavigationStackManager.rebuildNavigationHierarchy(svc: svc, collapsing: true)
        }
        return proposedTopColumn
    }
    
    func splitViewController(_ svc: UISplitViewController,
                             displayModeForExpandingToProposedDisplayMode
                             proposedDisplayMode: UISplitViewController.DisplayMode)
    -> UISplitViewController.DisplayMode {
        NavigationStackManager.saveHierarchyFromCompact(svc: svc)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            NavigationStackManager.rebuildNavigationHierarchy(svc: svc, collapsing: false)
//            if let secondaryNav = svc.viewController(for: .secondary) as? UINavigationController, NavigationStackManager.secondaryVC != nil {
//                secondaryNav.viewControllers = [NavigationStackManager.secondaryVC!]
//            }
        }
        return proposedDisplayMode
    }
}
