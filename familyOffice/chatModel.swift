//
//  chatModel.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 24/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation

struct chatModel {
    
    static let kName = "name"
    static let klastMessage = "lastMessage"
    static let kDate = "date"
    static let kPhotoUrl = "photoUrl"
    
    let name: String!
    let lastMessage: String!
    let date: String!
    var photoUrl: String!
    
    init(name: String, lastMessage: String, date: String, photoUrl: String) {
        self.name = name
        self.lastMessage = lastMessage
        self.date = date
        self.photoUrl = photoUrl
    }
    
    
    func toDictionary() -> NSDictionary {
        return [
            chatModel.kName : self.name,
            chatModel.klastMessage : self.lastMessage,
            chatModel.kDate : self.date,
            chatModel.kPhotoUrl : self.photoUrl
        ]
    }
    
    
}
