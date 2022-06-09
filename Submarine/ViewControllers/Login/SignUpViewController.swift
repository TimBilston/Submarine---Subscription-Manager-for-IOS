//
//  SignUpViewController.swift
//  Submarine
//
//  Created by Nick Exon on 9/6/2022.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var databaseController: FirebaseController?
    
    @IBAction func signUpClicked(_ sender: Any) {
        print("sign up button clicked")
        guard let username = emailField.text, let password = passwordField.text else {
            return
        }
        databaseController!.signUp(username: username, password: password)
        displayMessage(title: "Success", message: "User signed up")
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseController = FirebaseController()

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

}
