//
//  DatesModel.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 23/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
struct DateModel {
    
    static let kTitle = "title"
    static let kDescription = "description"
    static let kDate = "date"
    static let kHour = "hour"
    static let kPriority = "priority"
    static let kMembers = "members"
    let title: String!
    let description: String!
    let date: String!
    var hour: String!
    var priority: Int!
    var members: [String]!
    
    init(title: String, description: String, date: String, hour: String, priority: Int, members: [String]) {
        self.title = title
        self.description = description
        self.date = date
        self.hour = hour
        self.priority = priority
        self.members = members
    }
    
 
    func toDictionary() -> NSDictionary {
        return [
            DateModel.kTitle : self.title,
            DateModel.kDescription : self.description,
            DateModel.kHour : self.hour,
            DateModel.kPriority : self.priority,
            DateModel.kMembers : self.members
        ]
    }
    
    
}


