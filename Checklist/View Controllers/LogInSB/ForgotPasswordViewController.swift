import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTF: UITextField! {
        didSet {
            emailTF.layer.borderColor = UIColor.red.cgColor
            emailTF.placeholder = "email".localized
            emailTF.delegate = self
            emailTF.becomeFirstResponder()
        }
    }
    @IBOutlet weak var resetPasswordBtn: UIButton! {
        didSet {
            resetPasswordBtn.layer.cornerRadius = resetPasswordBtn.frame.height/2
            resetPasswordBtn.setTitle("resetPassword".localized, for: .normal)
            resetPasswordBtn.setTitleColor(.white, for: .normal)
            resetPasswordBtn.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func validateFields() {
        activityIndicator.startAnimating()
        view.endEditing(true)
        if emailTF.text == "" {
                Alerts.fillInAllFieldsAlert(emptyTextFields: [emailTF], presentAlertOn: self)
                activityIndicator.stopAnimating()
        }
        else {
            emailTF.layer.borderWidth = 0
            guard let email = emailTF.text else { return }
            Auth.auth().sendPasswordReset(withEmail: email) { [weak self] err in
                if err != nil {
                    DispatchQueue.main.async {
                        Alerts.errorAlert(fieldsToRemoveTextIn: nil, errorText: err!.localizedDescription, presentAlertOn: self)
                        self?.activityIndicator.stopAnimating()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Alerts.successfulPasswordResetAlert(navigationController: self?.navigationController, presentAlertOn: self)
                        self?.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
    
    @IBAction func resetPasswordBtnAction(_ sender: UIButton) {
        validateFields()
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validateFields()
        return true
    }
}
