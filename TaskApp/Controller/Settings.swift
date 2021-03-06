//
//  Settings.swift
//  TaskApp
//
//  Created by Ion M on 6/30/18.
//  Copyright © 2018 Ion M. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class Settings: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            FBSDKLoginManager().logOut()
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "goToLogin") as! Login
            present(loginVC, animated: true, completion: nil)
        } catch {
            Alert.showAlert(title: "Unable to logout", message: "Please check your internet connection", vc: self)
            print("There was an error logging out: \(error)")
        }
    }
}

extension Settings: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Share on Facebook"
        return cell
    }
}
