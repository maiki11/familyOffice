//
//  Proccess.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 07/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation

struct Proccess {
    let timestap : Double!
    let text: String!
    var status: String!
    let type: String!
    
    init(text: String, status: String!, type: String) {
        self.text = text
        self.status = status
        self.type = type
        self.timestap = Constants.Services.UTILITY_SERVICE.getDate()
    }
}
