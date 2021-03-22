//
//  AlertService.swift
//  Recipes
//
//  Created by Екатерина Григорьева on 22.03.2021.
//

import UIKit

class AlertService{
    
    func alert(message: String)->UIAlertController{
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
//        present(alert, animated: true)
        
        return alert
        
    }
}
