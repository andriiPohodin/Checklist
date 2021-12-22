import UIKit

class RootViewControllerForSplitView: UIViewController {
    
    private var navigationStack = [UIViewController]()
    private var wasPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
        if !wasPresented {
            performSegue(withIdentifier: "fromRoot", sender: nil)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        SplitViewBehaviourManager.showMasterInOverlay(splitViewController: splitViewController, viewHeight: size.height, viewWidth: size.width)
    }
}

extension RootViewControllerForSplitView: UISplitViewControllerDelegate, SplitViewHierarchyManager {
    
    //    var wasPresented: Bool {
    //        get {
    //            return false
    //        }
    //        set {}
    //    }
    
    //    var navigationStack: [UIViewController] {
    //        get {
    //            return [UIViewController]()
    //        }
    //        set {}
    //    }
    
    func transferNavigationStack(svc: UISplitViewController, collapsing: Bool) {
        guard let primaryNav = svc.viewController(for: .primary) as? UINavigationController else { return }
        guard let compactNav = svc.viewController(for: .compact) as? UINavigationController else { return }
        if collapsing {
            navigationStack = primaryNav.viewControllers
            navigationStack.removeFirst()
            primaryNav.popToRootViewController(animated: false)
            compactNav.popToRootViewController(animated: false)
            if let root = compactNav.topViewController as? RootViewControllerForSplitView {
                root.wasPresented = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                for vc in self.navigationStack {
                    compactNav.pushViewController(vc, animated: false)
                }
            }
        }
        else {
            navigationStack = compactNav.viewControllers
            navigationStack.removeFirst()
            compactNav.popToRootViewController(animated: false)
            primaryNav.popToRootViewController(animated: false)
            if let root = primaryNav.topViewController as? RootViewControllerForSplitView {
                root.wasPresented = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                for vc in self.navigationStack {
                    primaryNav.pushViewController(vc, animated: false)
                }
            }
        }
    }
    
    func splitViewController(_ svc: UISplitViewController,
                             topColumnForCollapsingToProposedTopColumn
                             proposedTopColumn: UISplitViewController.Column)
    -> UISplitViewController.Column {
        transferNavigationStack(svc: svc, collapsing: true)
        return proposedTopColumn
    }
    
    func splitViewController(_ svc: UISplitViewController,
                             displayModeForExpandingToProposedDisplayMode
                             proposedDisplayMode: UISplitViewController.DisplayMode)
    -> UISplitViewController.DisplayMode {
        transferNavigationStack(svc: svc, collapsing: false)
        return proposedDisplayMode
    }
}
