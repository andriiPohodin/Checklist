import UIKit

final class SplitViewBehaviourManager {
    
    static func showMasterInOverlay(splitViewController: UISplitViewController?, viewHeight: CGFloat, viewWidth: CGFloat) {
        if splitViewController != nil {
            if UIDevice.current.userInterfaceIdiom == .pad, viewHeight > viewWidth {
                splitViewController?.show(.primary)
            }
            else if UIDevice.current.userInterfaceIdiom == .phone, UIScreen.main.traitCollection.horizontalSizeClass == .regular {
                splitViewController?.show(.primary)
            }
        }
    }
}

protocol SplitViewHierarchyManager {
    
//    var wasPresented: Bool { get set }
//    var navigationStack: [UIViewController] { get set }
    
    func transferNavigationStack(svc: UISplitViewController, collapsing: Bool)
}
