//
//  Register.swift
//  TaskApp
//
//  Created by Ion M on 6/30/18.
//  Copyright © 2018 Ion M. All rights reserved.
//

import UIKit
import Firebase

class Register: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keyboard notifications
        subscribeToNotifications()
        
        emailTextField.delegate = TextFieldDelegate.sharedInstance
        passwordTextField.delegate = TextFieldDelegate.sharedInstance
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func registerTapped(_ sender: Any) {
        
        // Perform credentials validation
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
        
        let activityIndicator = UIViewController.startActivityIndicator(onView: self.view)
        
        // Set up a new user in our Firebase db if above validation passed
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
            if error != nil {
                UIViewController.stopActivityIndicator(activityIndicator)
                print("There was an error: \(error!)")
            } else {
                UIViewController.stopActivityIndicator(activityIndicator)
                self.performSegue(withIdentifier: "goToTasks", sender: self)
            }
        }
    }
    
    // Hide keyboard on touches outside the textField(s)
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // Shift view when keyboard pops up
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = -80
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
}
