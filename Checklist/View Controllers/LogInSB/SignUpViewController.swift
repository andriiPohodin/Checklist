import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
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
            confirmBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    private var initialOffset: CGPoint?
    private var keyboardHeight: CGFloat?
    private var textFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        textFields = [nameTf, phoneNumberTf, corporationTf, emailTf, passwordTf, confirmPasswordTf]
        for textField in textFields {
            textField.delegate = self
            textField.layer.borderColor = UIColor.red.cgColor
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleKeyboard(notification: Notification) {
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            if keyboardHeight == nil {
                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
                    keyboardHeight = keyboardSize.height
                    UIView.animate(withDuration: 0.3, animations: {
                        self.contentViewHeightConstraint.constant += self.keyboardHeight!
                    })
                    let distanceToBottom = scrollView.frame.size.height
                    let collapseSpace = keyboardHeight! - distanceToBottom
                    if collapseSpace < 0 {
                        return
                    }
                    UIView.animate(withDuration: 0.3, animations: {
                        self.scrollView.contentOffset = CGPoint(x: (self.initialOffset?.x)!, y: collapseSpace)
                    })
                }
            }
        case UIResponder.keyboardWillHideNotification:
            if keyboardHeight != nil {
                UIView.animate(withDuration: 0.3) {
                    self.contentViewHeightConstraint.constant -= self.keyboardHeight!
                    self.scrollView.contentOffset = self.initialOffset!
                }
                keyboardHeight = nil
            }
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
    
    @IBAction func SignUpViewEndEditingTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension SignUpViewController: UITextFieldDelegate, UIScrollViewDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
                initialOffset = scrollView.contentOffset
        return true
    }
    
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}
