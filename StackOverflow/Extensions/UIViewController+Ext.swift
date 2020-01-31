//
//  UIViewController+Ext.swift
//  StackOverflow
//
//  Created by sai on 31/01/20.
//  Copyright © 2020 sai. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = "Warning", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
