//
//  AlertService.swift
//  familyOffice
//
//  Created by miguel reina on 27/02/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import UIKit

class AlertService  {
    private init(){
    }
    
    public static func Instance() -> AlertService {
        return instance
    }
    static let instance : AlertService = AlertService()
    
    func alertMessage(context: UIViewController, title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        context.present(alert, animated: true, completion: nil)
    }
}
