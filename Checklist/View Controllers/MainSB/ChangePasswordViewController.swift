import UIKit
import FirebaseAuth

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var newPasswordTf: UITextField! {
        didSet {
            newPasswordTf.placeholder = "newPassword".localized
            newPasswordTf.layer.borderColor = UIColor.systemRed.cgColor
            newPasswordTf.becomeFirstResponder()
        }
    }
    @IBOutlet weak var confirmNewPasswordTf: UITextField! {
        didSet {
            confirmNewPasswordTf.placeholder = "confirmPassword".localized
            confirmNewPasswordTf.layer.borderColor = UIColor.systemRed.cgColor
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
    
    @IBAction func confirmBtnAction(_ sender: UIButton) {
        if newPasswordTf.text != "", confirmNewPasswordTf.text != "" {
            if newPasswordTf.text == confirmNewPasswordTf.text {
                Auth.auth().currentUser?.updatePassword(to: newPasswordTf.text!, completion: { [weak self] err in
                    if err != nil {
                        let alert = UIAlertController(title: "error".localized, message: err?.localizedDescription, preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "confirm".localized, style: .cancel, handler: nil)
                        alert.addAction(confirmAction)
                        self?.present(alert, animated: true, completion: nil)
                    }
                    else {
                        self?.newPasswordTf.layer.borderWidth = 0
                        self?.confirmNewPasswordTf.layer.borderWidth = 0
                        self?.navigationController?.popViewController(animated: true)
                    }
                })
            }
            else {
                let alert = UIAlertController(title: "error".localized, message: "passwordsDoNotMatch".localized, preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "confirm".localized, style: .cancel) { [weak self] _ in
                    DispatchQueue.main.async {
                        guard let textFields = self?.textFields else { return }
                        for textField in textFields {
                            textField.text = ""
                            textField.layer.borderWidth = 0
                        }
                        self?.newPasswordTf.becomeFirstResponder()
                    }
                }
                alert.addAction(confirmAction)
                present(alert, animated: true, completion: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "error".localized, message: "fillInAllFields".localized, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "confirm".localized, style: .cancel) { [weak self] _ in
                guard let textFields = self?.textFields else { return }
                for textField in textFields {
                    if textField.text == "" {
                        textField.layer.borderWidth = 2
                    }
                    else {
                        textField.layer.borderWidth = 0
                    }
                }
                let emptyTf = self?.textFields.first(where: { $0.text == ""})
                emptyTf?.becomeFirstResponder()
            }
            alert.addAction(confirmAction)
            present(alert, animated: true, completion: nil)
        }
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
