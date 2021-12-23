import UIKit

protocol SplitViewHierarchyManager {
    
//    var wasPresented: Bool { get set }
//    var navigationStack: [UIViewController] { get set }
    
    func transferNavigationStack(svc: UISplitViewController, collapsing: Bool)
}
