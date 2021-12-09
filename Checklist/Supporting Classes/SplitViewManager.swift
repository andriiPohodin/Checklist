import Foundation
import UIKit

class SplitViewManager {
    
    static func showMasterInOverlay(splitViewController: UISplitViewController?, viewBounds: CGRect) {
        if splitViewController != nil {
            if UIDevice.current.userInterfaceIdiom == .pad, viewBounds.height > viewBounds.width {
                splitViewController?.show(.primary)
            }
            else if UIDevice.current.userInterfaceIdiom == .phone, UIScreen.main.traitCollection.horizontalSizeClass == .regular {
                splitViewController?.show(.primary)
            }
        }
    }
}
