//
//  UIViewController+Ext.swift
//  StackOverflow
//
//  Created by sai on 31/01/20.
//  Copyright © 2020 sai. All rights reserved.
//

import UIKit

// Extension for UIViewController, additional methos related to view controller can be added here
extension UIViewController {
    
    /// Method to Show Alert in view controller
    /// - Parameters:
    ///   - title: Title to display in the alert
    ///   - message: Message to display in the alert
    func showAlert(title: String = "Warning", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
