//
//  AccountViewController.swift
//  Checklist
//
//  Created by Andrii Pohodin on 17.06.2021.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var logOutBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logOutBtnAction(_ sender: UIButton) {
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
