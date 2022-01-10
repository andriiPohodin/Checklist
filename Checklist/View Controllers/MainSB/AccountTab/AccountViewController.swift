import UIKit
import SPPermissions
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AccountViewController: UIViewController {
    
    private var textField = UITextField()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var helloLabel: UILabel! {
        didSet {
            guard let userName = UserSettings.defaults.string(forKey: UserSettings.userName) else { return }
            helloLabel.text = "Hello, ".localized + userName
            helloLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.isUserInteractionEnabled = true
//            profileImage.layer.cornerRadius = profileImage.frame.height/2
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
            profileImage.addGestureRecognizer(tapGesture)
            fetchImage()
        }
    }
    @IBOutlet weak var changeNameBtn: UIButton! {
        didSet {
            changeNameBtn.setTitle("changeName".localized, for: .normal)
            changeNameBtn.layer.cornerRadius = changeNameBtn.frame.height/2
            changeNameBtn.layer.backgroundColor = UIColor.systemGreen.cgColor
            changeNameBtn.setTitleColor(.white, for: .normal)
            changeNameBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var changePasswordBtn: UIButton! {
        didSet {
            changePasswordBtn.setTitle("changePassword".localized, for: .normal)
            changePasswordBtn.layer.cornerRadius = changePasswordBtn.frame.height/2
            changePasswordBtn.layer.backgroundColor = UIColor.systemGreen.cgColor
            changePasswordBtn.setTitleColor(.white, for: .normal)
            changeNameBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var signOutBtn: UIButton! {
        didSet {
            signOutBtn.setTitle("signOut".localized, for: .normal)
            signOutBtn.layer.borderWidth = 2
            signOutBtn.layer.borderColor = UIColor.systemGray5.cgColor
            signOutBtn.layer.cornerRadius = signOutBtn.frame.height/2
            signOutBtn.setTitleColor(.red, for: .normal)
            signOutBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    private func fetchImage() {
        guard let localUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(UserSettings.defaults.string(forKey: UserSettings.currentUserUid) ?? "") else { return }
        if NetworkMonitor.shared.isConnected {
            print("Network is connected")
            let imageRef = Storage.storage().reference(forURL: Constants.storageRef).child(UserSettings.defaults.string(forKey: UserSettings.currentUserUid)!)
            imageRef.getData(maxSize: 1024 * 1024) { [weak self] data, err in
                if err != nil {
                    if let data = try? Data(contentsOf: localUrl) {
                        DispatchQueue.main.async {
                            self?.profileImage.image = UIImage(data: data)
                            self?.activityIndicator.stopAnimating()
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self?.profileImage.image = UIImage(named: "defaultProfileImage")
                            self?.activityIndicator.stopAnimating()
                            print("No available image to upload")
                        }
                    }
                }
                else {
                    let downloadTask = imageRef.write(toFile: localUrl)
                    DispatchQueue.main.async {
                        self?.profileImage.image = UIImage(data: data!)
                        self?.activityIndicator.stopAnimating()
                    }
                    downloadTask.resume()
                }
            }
        }
        else {
            print("Network is not connected")
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: localUrl) {
                    DispatchQueue.main.async {
                        self.profileImage.image = UIImage(data: imageData)
                        self.activityIndicator.stopAnimating()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.profileImage.image = UIImage(named: "defaultProfileImage")
                        self.activityIndicator.stopAnimating()
                        print("No available image to upload")
                    }
                }
            }
        }
    }
    
    @objc private func didTapImage() {
        let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] (action: UIAlertAction) in
            let permission = SPPermissions.Permission.camera
            if permission.authorized {
                self?.presentImagePicker(sourceType: .camera)
            }
            else {
                let controller = SPPermissions.dialog([permission])
                controller.delegate = self
                controller.present(on: self!)
            }
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] (action: UIAlertAction) in
            let permission = SPPermissions.Permission.photoLibrary
            if permission.authorized {
                self?.presentImagePicker(sourceType: .photoLibrary)
            }
            else {
                let controller = SPPermissions.dialog([permission])
                controller.delegate = self
                controller.present(on: self!)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func saveNewProfileImage() {
        guard let imageData = self.profileImage.image?.jpegData(compressionQuality: 0.4) else { return }
        DispatchQueue.global().async {
            guard let localUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(UserSettings.defaults.string(forKey: UserSettings.currentUserUid)!) else { return }
            do {
                try imageData.write(to: localUrl)
            } catch {
                print(error.localizedDescription)
            }
            let storageRef = Storage.storage().reference(forURL: Constants.storageRef).child(UserSettings.defaults.string(forKey: UserSettings.currentUserUid)!)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storageRef.putData(imageData, metadata: metadata) { (storageMetaData, err) in
                if err != nil {
                    print(err!.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func changeNameBtnAction(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Enter your name", message: nil, preferredStyle: .alert)
        alertVC.addTextField { [weak self] textField in
            textField.text = UserSettings.defaults.string(forKey: UserSettings.userName)
            self?.textField = textField
        }
        let confirmAction = UIAlertAction(title: "confirm".localized, style: .cancel) { [weak self] _ in
            if self?.textField.text != "" {
                if NetworkMonitor.shared.isConnected {
                    guard let newName = self?.textField.text else { return }
                    let db = Firestore.firestore()
                    db.collection("users").document(UserSettings.defaults.string(forKey: UserSettings.currentUserUid)!).updateData(["name" : newName]) { err in
                        if err != nil {
                            print(err!.localizedDescription)
                        }
                        else {
                            UserSettings.changeUserName(newName: newName)
                            let text = "Hello, ".localized + newName
                            self?.helloLabel.text = text
                        }
                    }
                }
                else {
                    let alert = UIAlertController(title: "You are offline", message: "Unable to update name", preferredStyle: .alert)
                    let action = UIAlertAction(title: "confirm".localized, style: .cancel)
                    alert.addAction(action)
                    self?.present(alert, animated: true)
                }
            }
            else {
                self?.helloLabel.text = "Hello, ".localized + UserSettings.defaults.string(forKey: UserSettings.userName)!
            }
        }
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .destructive)
        alertVC.addAction(confirmAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true)
    }
    
    @IBAction func changePasswordBtnAction(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Are you sure?", message: "You need to re-login first", preferredStyle: .alert)
        alertVC.addTextField { emailTf in
            emailTf.placeholder = "email".localized
        }
        alertVC.addTextField { passwordTf in
            passwordTf.placeholder = "password".localized
            passwordTf.isSecureTextEntry = true
        }
        let confirmAction = UIAlertAction(title: "confirm".localized, style: .cancel) { [weak self] action in
            let email = alertVC.textFields?.first?.text
            let password = alertVC.textFields?.last?.text
            if email != "", password != "" {
                let credential: AuthCredential = EmailAuthProvider.credential(withEmail: email!, password: password!)
                Auth.auth().currentUser?.reauthenticate(with: credential, completion: { [weak self] result, error in
                    if error != nil {
                        let alertVc = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "confirm".localized, style: .cancel) { [weak self] action in
                            self?.view.isUserInteractionEnabled = false
                            alertVC.textFields?.first?.text = ""
                            alertVC.textFields?.last?.text = ""
                            self?.present(alertVC, animated: true, completion: nil)
                            self?.view.isUserInteractionEnabled = true
                        }
                        alertVc.addAction(confirmAction)
                        self?.present(alertVc, animated: true, completion: nil)
                        self?.view.isUserInteractionEnabled = true
                    }
                    else {
                        self?.view.isUserInteractionEnabled = true
                        self?.performSegue(withIdentifier: "toChangePassword", sender: nil)
                    }
                })
            }
            else {
                let alertVc = UIAlertController(title: "Error", message: "fillInAllFields".localized, preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "confirm".localized, style: .cancel) { [weak self] action in
                    self?.view.isUserInteractionEnabled = false
                    alertVC.textFields?.first?.text = ""
                    alertVC.textFields?.last?.text = ""
                    self?.present(alertVC, animated: true, completion: nil)
                    self?.view.isUserInteractionEnabled = true
                }
                alertVc.addAction(confirmAction)
                self?.present(alertVc, animated: true, completion: nil)
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .destructive, handler: nil)
        alertVC.addAction(confirmAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func signOutBtnAction(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Sign out", message: "Are you sure?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            UserSettings.removeUserDataAndGoToFirstVC()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        present(alertVC, animated: true, completion: nil)
    }
}

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if NetworkMonitor.shared.isConnected {
            guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
            profileImage.image = selectedImage
            saveNewProfileImage()
            picker.dismiss(animated: true, completion: nil)
        }
        else {
            picker.dismiss(animated: true, completion: nil)
            let alertVC = UIAlertController(title: "You are offline", message: "Unable to update profile image", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "confirm".localized, style: .cancel)
            alertVC.addAction(confirmAction)
            present(alertVC, animated: true)
        }
    }
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = sourceType
            picker.allowsEditing = true
            present(picker, animated: true)
        }
    }
}

extension AccountViewController: SPPermissionsDelegate {
    func didAllowPermission(_ permission: SPPermissions.Permission) {
        switch permission {
        case .camera:
            presentImagePicker(sourceType: .camera)
            print("Access to camera allowed")
        case .photoLibrary:
            presentImagePicker(sourceType: .photoLibrary)
            print("Access to photo library allowed")
        default:
            break
        }
    }
}
