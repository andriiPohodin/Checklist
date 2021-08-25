import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class UserSettings {
    static let userDefaults = UserDefaults.standard
    static let userName = "user"
    static let currentUserUid = "currentUserUid"
    
    static func setUserData(_ name: String, _ uid: String) {
        userDefaults.setValue(name, forKey: userName)
        userDefaults.setValue(uid, forKey: currentUserUid)
    }
    
    static func changeUserName(newName: String) {
        userDefaults.setValue(newName, forKey: userName)
    }
    
    static func removeUserDataAndGoToFirstVC() {
        userDefaults.removeObject(forKey: userName)
        userDefaults.removeObject(forKey: currentUserUid)
        Navigation.goToFirstVC()
    }
    
    static func getUserDataAndGoToMainVC(parentVC: UIViewController?) {
        guard let parentVC = parentVC else { return }
        let docRef = Firestore.firestore().collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")
        docRef.getDocuments { (snapshot, err) in
            if err != nil {
                Alerts.errorAlert(fieldsToRemoveTextIn: nil, errorText: err!.localizedDescription, presentAlertOn: parentVC)
            }
            else {
                let document = snapshot!.documents.first
                let data = document?.data()
                guard let name = data?["name"] as? String else { return }
                guard let uid = data?["uid"] as? String else { return }
                guard let localUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(uid) else { return }
                let storageRef = Storage.storage().reference(forURL: Constants.storageRef).child(uid)
                UserSettings.setUserData(name, uid)
                let downloadTask = storageRef.write(toFile: localUrl) { (url, err) in
                    if err != nil {
                        print("Profile image saving failed")
                    }
                }
                downloadTask.observe(.success) { (snapshot) in
                    print("Profile image saved")
                }
                Navigation.goToMainVC()
            }
        }
    }
}

