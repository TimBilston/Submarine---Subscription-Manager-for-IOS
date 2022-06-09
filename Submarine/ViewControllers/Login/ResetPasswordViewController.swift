//
//  ResetPasswordViewController.swift
//  Submarine
//
//  Created by Nick Exon on 9/6/2022.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {

    var databaseController: FirebaseController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseController = FirebaseController()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var emailField: UITextField!
    @IBAction func resetClicked(_ sender: Any) {
        guard let email = emailField.text else{
            displayMessage(title: "Missing Field", message: "Please enter an email")
            return
        }
        databaseController!.resetPassword(email: email)
        displayMessage(title: "Success", message: "Reset password email sent")
        dismiss(animated: true, completion: nil)
    }
    
    /*nbbb
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
