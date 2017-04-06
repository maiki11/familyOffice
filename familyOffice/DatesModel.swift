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
    static let kEndDate = "endDate"
    static let kPriority = "priority"
    static let kMembers = "members"
    
    var title: String!
    var description: String!
    var date: String!
    var endDate: String!
    var priority: Int!
    var members: [String]!
    
    init(title: String, description: String, date: String, endDate: String, priority: Int, members: [String]) {
        self.title = title
        self.description = description
        self.date = date
        self.endDate = endDate
        self.priority = priority
        self.members = members
    }
    
 
    func toDictionary() -> NSDictionary {
        return [
            DateModel.kTitle : self.title,
            DateModel.kDescription : self.description,
            DateModel.kEndDate : self.endDate,
            DateModel.kPriority : self.priority,
            DateModel.kMembers : self.members
        ]
    }
    
    
}



