//
//  Login.swift
//  TaskApp
//
//  Created by Ion M on 6/30/18.
//  Copyright © 2018 Ion M. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class Login: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fbLoginStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if (FBSDKAccessToken.current() != nil) {
        //            performSegue(withIdentifier: "goToTasks", sender: self)
        //        }
        
        // Log out if the user was logged in when terminated the app
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email"]
        fbLoginStackView.addArrangedSubview(loginButton)
        loginButton.delegate = self
        
        subscribeToNotifications()
        
        emailTextField.delegate = TextFieldDelegate.sharedInstance
        passwordTextField.delegate = TextFieldDelegate.sharedInstance
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
                Alert.showAlert(title: "Login Failed", message: "Email or password are incorrect", vc: self)
                print("There was an error: \(error!)")
            } else {
                self.performSegue(withIdentifier: "goToTasks", sender: self)
                
            }
        }
    }
    
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

// MARK:- Facebook Login Delegates
extension Login: FBSDKLoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out from Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                Alert.showAlert(title: "Whoops", message: "Failed to login with Facebook", vc: self)
                print("There was an error signing in with facebook: \(error)")
                return
            }
            self.performSegue(withIdentifier: "goToTasks", sender: self)
        }
    }
}
