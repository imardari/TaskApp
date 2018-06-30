//
//  Login.swift
//  TaskApp
//
//  Created by Ion M on 6/30/18.
//  Copyright © 2018 Ion M. All rights reserved.
//

import UIKit
import Firebase

class Login: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if email.isEmpty || password.isEmpty {
            Alert.showAlert(title: "Incomplete", message: "Please fill out both email and password fields", vc: self)
        }
        
        if !email.isValidEmail {
            Alert.showAlert(title: "Invalid email format", message: "Please make sure you format your email correctly", vc: self)
        }
        
        if password.count < 6 {
            Alert.showAlert(title: "Password too short", message: "Password should be at least 6 characters long", vc: self)
        }
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
            if error != nil {
                print("There was an error: \(error!)")
            } else {
                self.performSegue(withIdentifier: "goToTasks", sender: self)
                
            }
        }
    }
}
