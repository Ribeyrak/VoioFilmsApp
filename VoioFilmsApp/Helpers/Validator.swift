//
//  Validator.swift
//  VoioFilmsApp
//
//  Created by Evhen Lukhtan on 28.03.2023.
//

import UIKit

class Validator: NSObject {
    
    func simpleAlert(vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
}
