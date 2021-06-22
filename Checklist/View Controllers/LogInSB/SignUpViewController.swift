import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField! {
        didSet {
            nameTF.placeholder = "name".localized
        }
    }
    @IBOutlet weak var phoneNumberTF: UITextField! {
        didSet {
            phoneNumberTF.placeholder = "phone".localized
        }
    }
    @IBOutlet weak var emailTF: UITextField! {
        didSet {
            emailTF.placeholder = "email".localized
        }
    }
    @IBOutlet weak var passwordTF: UITextField! {
        didSet {
            passwordTF.placeholder = "password".localized
        }
    }
    @IBOutlet weak var confirmPasswordTF: UITextField! {
        didSet {
            confirmPasswordTF.placeholder = "confirmPassword".localized
        }
    }
    @IBOutlet weak var confirmBtn: UIButton! {
        didSet {
            confirmBtn.layer.cornerRadius = CGFloat(confirmBtn.frame.height/2)
            confirmBtn.layer.backgroundColor = UIColor.systemBlue.cgColor
            confirmBtn.setTitle("confirm".localized, for: .normal)
            confirmBtn.setTitleColor(.white, for: .normal)
            confirmBtn.titleLabel?.font = .systemFont(ofSize: 25)
        }
    }
    var textFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [nameTF, phoneNumberTF, emailTF, passwordTF, confirmPasswordTF]
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
    
    @objc func keyboardWillChange(notification: Notification) {
        switch notification.name {
        case UIResponder.keyboardDidShowNotification:
            if nameTF.isFirstResponder {
                view.frame.origin.y = 0
            }
            else if phoneNumberTF.isFirstResponder {
                view.frame.origin.y = 0
            }
            else if emailTF.isFirstResponder {
                view.frame.origin.y = -emailTF.frame.height
            }
            else if passwordTF.isFirstResponder {
                view.frame.origin.y = -passwordTF.frame.height
            }
            else if confirmPasswordTF.isFirstResponder {
                view.frame.origin.y = -confirmPasswordTF.frame.height
            }
            else { return }
        case UIResponder.keyboardWillHideNotification:
            view.frame.origin.y = 0
        default: break
        }
    }
    
    func changeTextFieldBorderWidth() {
        for textField in textFields {
            switch textField.text {
            case "":
                textField.layer.borderWidth = 2
            default:
                textField.layer.borderWidth = 0
            }
        }
    }
    
    func properTextFieldShouldBecomeFirstResponder() {
        let textField = textFields.first(where: {
            $0.text == ""
        })
        textField?.becomeFirstResponder()
    }
    
    func validateFields() {
        view.endEditing(true)
        if nameTF.text == "" || phoneNumberTF.text == "" || emailTF.text == "" || passwordTF.text == "" || confirmPasswordTF.text == "" {
            let alert = UIAlertController(title: "error".localized, message: "fillInAllFields".localized, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.properTextFieldShouldBecomeFirstResponder()
                }
            }
            alert.addAction(okAction)
            present(alert, animated: true) { [weak self] in
                DispatchQueue.main.async {
                    self?.changeTextFieldBorderWidth()
                }
            }
        }
        else {
            if PasswordValidator.isPasswordValid(passwordTF.text!) == true {
                if passwordTF.text == confirmPasswordTF.text {
                    let name = nameTF.text!
                    let phoneNumber = phoneNumberTF.text!
                    let email = emailTF.text!
                    let password = passwordTF.text!
                    Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, err) in
                        if err != nil {
                            let alertVC = UIAlertController(title: "error".localized, message: err?.localizedDescription, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                            alertVC.addAction(okAction)
                            self?.present(alertVC, animated: true, completion: nil)
                        }
                        else {
                            let db = Firestore.firestore()
                            db.collection("users").document("\(result!.user.uid)").setData(["name":name, "phoneNumber":phoneNumber, "uid":result!.user.uid]) { [weak self] err in
                                if err != nil {
                                    let alertVC = UIAlertController(title: "error".localized, message: err?.localizedDescription, preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                                    alertVC.addAction(okAction)
                                    self?.present(alertVC, animated: true, completion: nil)
                                }
                                else {
                                    UserSettings.setUserData(name, Auth.auth().currentUser!.uid)
                                    guard let localUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(Auth.auth().currentUser!.uid) else { return }
                                    let storageRef = Storage.storage().reference(forURL: Constants.storageRef).child(Auth.auth().currentUser!.uid)
                                    let img = UIImage(named: "defaultProfileImage")
                                    guard let imageData = img?.jpegData(compressionQuality: 0.4) else { return }
                                    do {
                                        try imageData.write(to: localUrl)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                    let metadata = StorageMetadata()
                                    metadata.contentType = "image/jpeg"
                                    storageRef.putData(imageData, metadata: metadata) { (storageMetaData, err) in
                                        if err != nil {
                                            print(err!.localizedDescription)
                                            return
                                        }
                                    }
                                }
                            }
                            Navigation.goToMainVC()
                        }
                    }
                }
                else {
                    let alert = UIAlertController(title: "error".localized, message: "passwordsDoNotMatch".localized, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in
                        DispatchQueue.main.async {
                            self?.passwordTF.becomeFirstResponder()
                        }
                    }
                    alert.addAction(okAction)
                    present(alert, animated: true) { [weak self] in
                        DispatchQueue.main.async {
                            self?.passwordTF.text = ""
                            self?.confirmPasswordTF.text = ""
                            self?.changeTextFieldBorderWidth()
                        }
                    }
                }
            }
            else {
                let alert = UIAlertController(title: "error".localized, message: "passwordShouldContain".localized, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.passwordTF.becomeFirstResponder()
                    }
                }
                alert.addAction(okAction)
                present(alert, animated: true) { [weak self] in
                    DispatchQueue.main.async {
                        self?.passwordTF.text = ""
                        self?.confirmPasswordTF.text = ""
                        self?.changeTextFieldBorderWidth()
                    }
                }
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
        case nameTF:
            phoneNumberTF.becomeFirstResponder()
        case phoneNumberTF:
            emailTF.becomeFirstResponder()
        case emailTF:
            passwordTF.becomeFirstResponder()
        case passwordTF:
            confirmPasswordTF.becomeFirstResponder()
        case confirmPasswordTF:
            confirmPasswordTF.resignFirstResponder()
            validateFields()
        default: break
        }
        return true
    }
}
