import UIKit
import SPPermissions
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AccountViewController: UIViewController {
    
    var textField = UITextField()
    
    @IBOutlet weak var helloLabel: UILabel! {
        didSet {
            guard let userName = UserSettings.defaults.string(forKey: UserSettings.userName) else { return }
            helloLabel.text = "Hello, ".localized + userName
        }
    }
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.isUserInteractionEnabled = true
            profileImage.layer.cornerRadius = profileImage.frame.width/2
            guard let localUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(UserSettings.defaults.string(forKey: UserSettings.currentUserUid)!) else { return }
            do {
                let imageData = try Data(contentsOf: localUrl)
                profileImage.image = UIImage(data: imageData)
            } catch {
                print("Error uploading image : \(error)")
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
            profileImage.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var changeNameBtn: UIButton! {
        didSet {
            changeNameBtn.setTitle("changeName".localized, for: .normal)
            changeNameBtn.layer.cornerRadius = changeNameBtn.frame.height/2
            changeNameBtn.layer.backgroundColor = UIColor.systemBlue.cgColor
            changeNameBtn.setTitleColor(.white, for: .normal)
        }
    }
    @IBOutlet weak var changePasswordBtn: UIButton! {
        didSet {
            changePasswordBtn.setTitle("changePassword".localized, for: .normal)
            changePasswordBtn.layer.cornerRadius = changePasswordBtn.frame.height/2
            changePasswordBtn.layer.backgroundColor = UIColor.systemBlue.cgColor
            changePasswordBtn.setTitleColor(.white, for: .normal)
        }
    }
    @IBOutlet weak var signOutBtn: UIButton! {
        didSet {
            signOutBtn.setTitle("signOut".localized, for: .normal)
            signOutBtn.layer.cornerRadius = signOutBtn.frame.height/2
            signOutBtn.setTitleColor(.red, for: .normal)
        }
    }
    
    @objc func didTapImage() {
        let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [ weak self ] (action: UIAlertAction) in
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
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [ weak self ] (action: UIAlertAction) in
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
    
    func saveNewProfileImage() {
        guard let imageData = profileImage.image?.jpegData(compressionQuality: 0.4) else { return }
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
    
    @IBAction func changeNameBtnAction(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Enter your name", message: nil, preferredStyle: .alert)
        alertVC.addTextField { [weak self] textField in
            textField.text = UserSettings.defaults.string(forKey: UserSettings.userName)
            self?.textField = textField
        }
        let confirmAction = UIAlertAction(title: "Confirm", style: .cancel) { [weak self] _ in
            if self?.textField.text != "" {
                guard let newName = self?.textField.text else { return }
                let text = "Hello, ".localized + newName
                self?.helloLabel.text = text
                let db = Firestore.firestore()
                db.collection("users").document(UserSettings.defaults.string(forKey: UserSettings.currentUserUid)!).updateData(["name" : newName]) { err in
                    if err != nil {
                        print(err!.localizedDescription)
                    }
                    else {
                        UserSettings.changeUserName(newName: newName)
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .destructive)
        alertVC.addAction(confirmAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }

    @IBAction func changePasswordBtnAction(_ sender: UIButton) {
        
    }
    
    @IBAction func signOutBtnAction(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Sign out", message: "Are you sure?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            Navigation.goToFirstVC()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        present(alertVC, animated: true, completion: nil)
    }
}

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        profileImage.image = selectedImage
        saveNewProfileImage()
        picker.dismiss(animated: true, completion: nil)
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
