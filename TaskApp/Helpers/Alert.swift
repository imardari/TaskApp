//
//  Alert.swift
//  TaskApp
//
//  Created by Ion M on 6/30/18.
//  Copyright © 2018 Ion M. All rights reserved.
//

import UIKit

class Alert {
    class func showAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
