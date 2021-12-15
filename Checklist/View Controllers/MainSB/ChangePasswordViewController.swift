import UIKit
import FirebaseAuth

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var newPasswordTf: UITextField! {
        didSet {
            newPasswordTf.placeholder = "newPassword".localized
            newPasswordTf.layer.borderColor = UIColor.systemRed.cgColor
            newPasswordTf.isSecureTextEntry = true
            newPasswordTf.becomeFirstResponder()
        }
    }
    @IBOutlet weak var confirmNewPasswordTf: UITextField! {
        didSet {
            confirmNewPasswordTf.placeholder = "confirmPassword".localized
            confirmNewPasswordTf.layer.borderColor = UIColor.systemRed.cgColor
            confirmNewPasswordTf.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var confirmBtn: UIButton! {
        didSet {
            confirmBtn.layer.cornerRadius = confirmBtn.frame.height/2
            confirmBtn.titleLabel?.font = .systemFont(ofSize: 25)
            confirmBtn.setTitle("confirm".localized, for: .normal)
            confirmBtn.setTitleColor(.white, for: .normal)
            confirmBtn.layer.backgroundColor = UIColor.systemRed.cgColor
        }
    }
    var textFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [newPasswordTf, confirmNewPasswordTf]
        for tf in textFields {
            tf.delegate = self
            tf.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func validateFields() {
        view.endEditing(true)
        var emptyTextFields = [UITextField]()
        for emptyField in textFields {
            if emptyField.text == "" {
                emptyTextFields.append(emptyField)
            }
            else {
                emptyField.layer.borderWidth = 0
            }
        }
        if !emptyTextFields.isEmpty {
            Alerts.fillInAllFieldsAlert(emptyTextFields: emptyTextFields, presentAlertOn: self)
            emptyTextFields.removeAll()
        }
        else {
            if newPasswordTf.text == confirmNewPasswordTf.text {
                if PasswordValidator.isPasswordValid(newPasswordTf.text!) == true {
                    Auth.auth().currentUser?.updatePassword(to: newPasswordTf.text!, completion: { [weak self] err in
                        if err != nil {
                            Alerts.errorAlert(fieldsToRemoveTextIn: nil, errorText: err!.localizedDescription.localized, presentAlertOn: self)
                        }
                        else {
                            self?.newPasswordTf.layer.borderWidth = 0
                            self?.confirmNewPasswordTf.layer.borderWidth = 0
                            self?.navigationController?.popViewController(animated: true)
                        }
                    })
                }
                else {
                    Alerts.errorAlert(fieldsToRemoveTextIn: textFields, errorText: "passwordShouldContain".localized, presentAlertOn: self)
                }
            }
            else {
                Alerts.errorAlert(fieldsToRemoveTextIn: textFields, errorText: "passwordsDoNotMatch".localized, presentAlertOn: self)
            }
        }
    }
    
    @IBAction func confirmBtnAction(_ sender: UIButton) {
        validateFields()
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case newPasswordTf:
            confirmNewPasswordTf.becomeFirstResponder()
        case confirmNewPasswordTf:
            navigationController?.popViewController(animated: true)
        default:
            break
        }
        return true
    }
}
