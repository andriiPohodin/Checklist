import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameTf: UITextField! {
        didSet {
            nameTf.placeholder = "name".localized
            nameTf.becomeFirstResponder()
        }
    }
    @IBOutlet weak var phoneNumberTf: UITextField! {
        didSet {
            phoneNumberTf.placeholder = "phone".localized
        }
    }
    @IBOutlet weak var corporationTf: UITextField! {
        didSet {
            corporationTf.placeholder = "corporation".localized
        }
    }
    @IBOutlet weak var emailTf: UITextField! {
        didSet {
            emailTf.placeholder = "email".localized
        }
    }
    @IBOutlet weak var passwordTf: UITextField! {
        didSet {
            passwordTf.placeholder = "password".localized
        }
    }
    @IBOutlet weak var confirmPasswordTf: UITextField! {
        didSet {
            confirmPasswordTf.placeholder = "confirmPassword".localized
        }
    }
    @IBOutlet weak var confirmBtn: UIButton! {
        didSet {
            confirmBtn.layer.cornerRadius = CGFloat(confirmBtn.frame.height/2)
            confirmBtn.layer.backgroundColor = UIColor.systemGreen.cgColor
            confirmBtn.setTitle("confirm".localized, for: .normal)
            confirmBtn.setTitleColor(.white, for: .normal)
            confirmBtn.titleLabel?.font = .systemFont(ofSize: 25)
        }
    }
    private var textFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [nameTf, phoneNumberTf, corporationTf, emailTf, passwordTf, confirmPasswordTf]
        for textField in textFields {
            textField.delegate = self
            textField.layer.borderColor = UIColor.red.cgColor
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillChange(notification: Notification) {
        switch notification.name {
        case UIResponder.keyboardDidShowNotification:
            if nameTf.isFirstResponder {
                view.frame.origin.y = 0
            }
            else if phoneNumberTf.isFirstResponder {
                view.frame.origin.y = 0
            }
            else if corporationTf.isFirstResponder {
                view.frame.origin.y = -corporationTf.frame.height
            }
            else if emailTf.isFirstResponder {
                view.frame.origin.y = -emailTf.frame.height
            }
            else if passwordTf.isFirstResponder {
                view.frame.origin.y = -passwordTf.frame.height*2
            }
            else if confirmPasswordTf.isFirstResponder {
                view.frame.origin.y = -confirmPasswordTf.frame.height*2
            }
            else { return }
        case UIResponder.keyboardWillHideNotification:
            view.frame.origin.y = 0
        default: break
        }
    }
    
    private func validateFields() {
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
            activityIndicator.stopAnimating()
            emptyTextFields.removeAll()
        }
        else {
            if PasswordValidator.isPasswordValid(passwordTf.text!) == true {
                if passwordTf.text == confirmPasswordTf.text {
                    guard let name = nameTf.text else { return }
                    guard let phoneNumber = phoneNumberTf.text else { return }
                    guard let corporation = corporationTf.text else { return }
                    guard let email = emailTf.text else { return }
                    guard let password = passwordTf.text else { return }
                    Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, err) in
                        if err != nil {
                            DispatchQueue.main.async {
                                Alerts.errorAlert(fieldsToRemoveTextIn: nil, errorText: err!.localizedDescription, presentAlertOn: self)
                                self?.activityIndicator.stopAnimating()
                            }
                        }
                        else {
                            let db = Firestore.firestore()
                            db.collection("users").document("\(result!.user.uid)").setData(["name":name, "corporation":corporation, "email":email, "phoneNumber":phoneNumber, "uid":result!.user.uid]) { [weak self] err in
                                if err != nil {
                                    DispatchQueue.main.async {
                                        Alerts.errorAlert(fieldsToRemoveTextIn: nil, errorText: err!.localizedDescription, presentAlertOn: self)
                                        self?.activityIndicator.stopAnimating()
                                    }
                                }
                                else {
                                    UserSettings.setUserData(name, result!.user.uid)
                                    DispatchQueue.main.async {
                                        self?.activityIndicator.stopAnimating()
                                        Navigation.goToMainVC()
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    Alerts.errorAlert(fieldsToRemoveTextIn: [passwordTf, confirmPasswordTf], errorText: "passwordsDoNotMatch", presentAlertOn: self)
                    activityIndicator.stopAnimating()
                }
            }
            else {
                Alerts.errorAlert(fieldsToRemoveTextIn: [passwordTf, confirmPasswordTf], errorText: "passwordShouldContain", presentAlertOn: self)
                activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func confirmBtnAction(_ sender: UIButton) {
        validateFields()
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTf:
            phoneNumberTf.becomeFirstResponder()
        case phoneNumberTf:
            corporationTf.becomeFirstResponder()
        case corporationTf:
            emailTf.becomeFirstResponder()
        case emailTf:
            passwordTf.becomeFirstResponder()
        case passwordTf:
            confirmPasswordTf.becomeFirstResponder()
        case confirmPasswordTf:
            confirmPasswordTf.resignFirstResponder()
            validateFields()
        default: break
        }
        return true
    }
}
