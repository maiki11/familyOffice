//
//  configProfile.swift
//  familyOffice
//
//  Created by miguel reina on 16/01/17.
//  Copyright © 2017 Miguel Reina y Leonardo Durazo. All rights reserved.
//

import Foundation
import UIKit

class ConfigProfile: NSObject {
    
    var name: String!
    var icon: UIImage!
    
    init(name: String, photoURL: NSURL, icon: UIImage){
        self.name = name
        self.icon = icon
    }
    
    deinit {
        print("Objeto destruido")
    }
    
    
    
}
