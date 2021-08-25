import UIKit
import SPPermissions

class Alerts {
        
    static func fillInAllFieldsAlert(emptyTextFields: [UITextField], presentAlertOn: UIViewController?) {
        let alert = UIAlertController(title: "error".localized, message: "fillInAllFields".localized, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "confirm".localized, style: .cancel) { _ in
            for textField in emptyTextFields {
                textField.layer.borderWidth = 2
            }
            emptyTextFields.first?.becomeFirstResponder()
        }
        alert.addAction(confirmAction)
        guard let vc = presentAlertOn else {
            print("Parent VC no more exist!")
            return
        }
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func errorAlert(fieldsToRemoveTextIn: [UITextField]?, errorText: String, presentAlertOn: UIViewController?) {
        let alert = UIAlertController(title: "error".localized, message: errorText.localized, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "confirm".localized, style: .cancel) { _ in
            guard let textFields = fieldsToRemoveTextIn else { return }
            for textField in textFields {
                textField.text = ""
                textField.layer.borderWidth = 2
            }
            textFields.first?.becomeFirstResponder()
        }
        alert.addAction(confirmAction)
        guard let vc = presentAlertOn else {
            print("Parent VC no more exist!")
            return
        }
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func successfulPasswordResetAlert(navigationController: UINavigationController?, presentAlertOn: UIViewController?) {
        guard let navigationController = navigationController else { return }
        let alert = UIAlertController(title: "resetTitle".localized, message: "resetMessage".localized, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "confirm".localized, style: .cancel) { _ in
            navigationController.popViewController(animated: true)
        }
        alert.addAction(confirmAction)
        guard let vc = presentAlertOn else {
            print("Parent VC no more exist!")
            return
        }
        vc.present(alert, animated: true, completion: nil)
    }
}

