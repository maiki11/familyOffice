//
//  family.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 06/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import UIKit

class Family: NSObject {
    
    var id: String!
    var name: String!
    var photoURL: NSURL!
    var photo: UIImage!
    
    init(name: String, photoURL: NSURL, photo: UIImage){
        self.name = name
        self.photoURL = photoURL
        self.photo = photo
    }
    
    deinit {
       print("Objeto destruido")
    }
    
    
    
}
