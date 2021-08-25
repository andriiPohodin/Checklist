import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class LogInViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTf: UITextField! {
        didSet {
            emailTf.placeholder = "email".localized
            emailTf.becomeFirstResponder()
        }
    }
    @IBOutlet weak var passwordTf: UITextField! {
        didSet {
            passwordTf.placeholder = "password".localized
        }
    }
    @IBOutlet weak var confirmBtn: UIButton! {
        didSet {
            confirmBtn.layer.cornerRadius = confirmBtn.frame.height/2
            confirmBtn.titleLabel?.font = .systemFont(ofSize: 25)
            confirmBtn.setTitle("confirm".localized, for: .normal)
            confirmBtn.setTitleColor(.white, for: .normal)
            confirmBtn.layer.backgroundColor = UIColor.systemBlue.cgColor
        }
    }
    @IBOutlet weak var forgotPasswordBtn: UIButton! {
        didSet {
            forgotPasswordBtn.setTitle("forgotPassword".localized, for: .normal)
            forgotPasswordBtn.titleLabel?.font = .systemFont(ofSize: 22)
            forgotPasswordBtn.setTitleColor(.systemBlue, for: .normal)
            forgotPasswordBtn.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    var textFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [emailTf, passwordTf]
        for textField in textFields {
            textField.delegate = self
            textField.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        activityIndicator.stopAnimating()
    }
    
    func validateFields() {
        activityIndicator.startAnimating()
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
            activityIndicator.stopAnimating()
        }
        else {
            guard let email = emailTf.text else { return }
            guard let password = passwordTf.text else { return }
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
                if error != nil {
                    switch error!.localizedDescription {
                    case "The password is invalid or the user does not have a password.":
                        guard let passwordTf = self?.passwordTf else { return }
                        Alerts.errorAlert(fieldsToRemoveTextIn: [passwordTf], errorText: error!.localizedDescription, presentAlertOn: self)
                        self?.activityIndicator.stopAnimating()
                    default:
                        Alerts.errorAlert(fieldsToRemoveTextIn: self?.textFields, errorText: error!.localizedDescription, presentAlertOn: self)
                        self?.activityIndicator.stopAnimating()
                    }
                }
                else {
                    UserSettings.getUserDataAndGoToMainVC(parentVC: self)
                }
            }
        }
    }
    
    @IBAction func confirmBtnAction(_ sender: UIButton) {
        validateFields()
    }
    
    @IBAction func forgotPasswordBtnAction(_ sender: UIButton) {
        for textField in textFields {
            textField.layer.borderWidth = 0
            textField.text = ""
        }
        performSegue(withIdentifier: "toForgotPassword", sender: nil)
    }
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTf:
            passwordTf.becomeFirstResponder()
        case passwordTf:
            passwordTf.resignFirstResponder()
            validateFields()
        default:
            break
        }
        return true
    }
}
