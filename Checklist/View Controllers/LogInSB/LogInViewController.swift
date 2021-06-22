import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class LogInViewController: UIViewController {
    
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
        textFields = [emailTF, passwordTF]
        for textField in textFields {
            textField.delegate = self
            textField.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
    
    private func getUserData() {
        let docRef = Firestore.firestore().collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")
        docRef.getDocuments { (snapshot, err) in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                let document = snapshot!.documents.first
                let data = document?.data()
                guard let name = data?["name"] else { return }
                guard let localUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(Auth.auth().currentUser!.uid) else { return }
                let storageRef = Storage.storage().reference(forURL: Constants.storageRef).child(Auth.auth().currentUser!.uid)
                UserSettings.setUserData(name as! String, Auth.auth().currentUser!.uid)
                let downloadTask = storageRef.write(toFile: localUrl) { (url, err) in
                    if err != nil {
                        print(err!.localizedDescription)
                    }
                }
                downloadTask.observe(.success) { (snapshot) in
                    print("Image successfuly downloaded")
                }
            }
        }
    }
    
    func validateFields() {
        view.endEditing(true)
        if emailTF.text == "" || passwordTF.text == "" {
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
            let email = emailTF.text!
            let password = passwordTF.text!
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, err) in
                if err != nil {
                    let alertVC = UIAlertController(title: "error".localized, message: err?.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertVC.addAction(okAction)
                    self?.present(alertVC, animated: true, completion: nil)
                }
                else {
                    self?.getUserData()
                    Navigation.goToMainVC()
                }
                //            if passwordTF.text == "1" {
                //                Navigation.goToMainVC()
                //            }
                //            else {
                //                let alert = UIAlertController(title: "error".localized, message: "wrongPassword".localized, preferredStyle: .alert)
                //                let okAction = UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in
                //                    DispatchQueue.main.async {
                //                        self?.passwordTF.becomeFirstResponder()
                //                    }
                //                }
                //                alert.addAction(okAction)
                //                present(alert, animated: true) { [weak self] in
                //                    DispatchQueue.main.async {
                //                        self?.passwordTF.text = ""
                //                        self?.changeTextFieldBorderWidth()
                //                    }
                //                }
            }
        }
    }
    
    @IBAction func confirmBtnAction(_ sender: UIButton) {
        validateFields()
    }
    
    @IBAction func forgotPasswordBtnAction(_ sender: UIButton) {
        for textField in textFields {
            textField.layer.borderWidth = 0
        }
        if emailTF.text == "" {
            emailTF.becomeFirstResponder()
        }
        else {
            passwordTF.text = ""
            passwordTF.becomeFirstResponder()
        }
        performSegue(withIdentifier: "toForgotPassword", sender: nil)
    }
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTF:
            passwordTF.becomeFirstResponder()
        case passwordTF:
            passwordTF.resignFirstResponder()
            validateFields()
        default:
            break
        }
        return true
    }
}
