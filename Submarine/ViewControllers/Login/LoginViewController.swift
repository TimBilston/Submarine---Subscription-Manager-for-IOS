//
//  LoginViewController.swift
//  Submarine
//
//  Created by Nick Exon on 17/4/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    lazy var authController: Auth = {
        return Auth.auth()
    }()
    var username: String?
    var password: String?
    var databaseController: FirebaseController?
    var authHandle: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        authHandle = Auth.auth().addStateDidChangeListener() {
//            (auth, user) in
//            guard user != nil else {return}
//            //change root controller
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //authController.removeStateDidChangeListener(authHandle!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseController = FirebaseController()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func usernameTextChanged(_ sender: Any) {
        username = usernameField.text
    }
    @IBAction func passwordTextChanged(_ sender: Any) {
        password = passwordField.text
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        databaseController!.login(username: username,password: password)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            if self.authController.currentUser == nil{
                self.displayMessage(title: "Login Error", message: "Incorrect Username or Password:")
            }
        }
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func LoggedInRedirect() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
}
