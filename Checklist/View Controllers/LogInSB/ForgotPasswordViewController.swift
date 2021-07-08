import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField! {
        didSet {
            emailTF.layer.borderColor = UIColor.red.cgColor
            emailTF.placeholder = "email".localized
            emailTF.delegate = self
        }
    }
    @IBOutlet weak var resetPasswordBtn: UIButton! {
        didSet {
            resetPasswordBtn.layer.cornerRadius = resetPasswordBtn.frame.height/2
            resetPasswordBtn.layer.backgroundColor = UIColor.systemBlue.cgColor
            resetPasswordBtn.setTitle("resetPassword".localized, for: .normal)
            resetPasswordBtn.setTitleColor(.white, for: .normal)
            resetPasswordBtn.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func validateFields() {
        view.endEditing(true)
        if emailTF.text == "" {
            let alert = UIAlertController(title: "error".localized, message: "fillInAllFields".localized, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.emailTF.becomeFirstResponder()
                }
            }
            alert.addAction(okAction)
            present(alert, animated: true) { [weak self] in
                DispatchQueue.main.async {
                    self?.emailTF.layer.borderWidth = 2
                }
            }
        }
        else {
            guard let email = emailTF.text else { return }
            Auth.auth().sendPasswordReset(withEmail: email) { err in
                if err != nil {
                    print(err!.localizedDescription)
                }
            }
            let alert = UIAlertController(title: "resetTitle".localized, message: "resetMessage".localized, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            alert.addAction(okAction)
            present(alert, animated: true) { [weak self] in
                self?.emailTF.layer.borderWidth = 0
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
