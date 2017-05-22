//
//  DatesModel.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 23/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Firebase
struct Event {
    
    static let kId = "Id"
    static let kTitle = "title"
    static let kDescription = "description"
    static let kDate = "date"
    static let kEndDate = "endDate"
    static let kPriority = "priority"
    static let kMembers = "members"
    static let kreminder = "reminder"
    static let klocation = "location"
    static let kcreator = "creator"
    
    var id: String!
    var title: String!
    var description: String!
    var date: String!
    var endDate: String!
    var priority: Int!
    var reminder: String?
    var members: [String]!
    var location: Location? = nil
    var creator: String!
    
    init(id: String, title: String, description: String, date: String, endDate: String, priority: Int, members: [String], reminder: String = "") {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.endDate = endDate
        self.priority = priority
        self.members = members
        self.reminder = reminder
        self.creator = Constants.Services.USER_SERVICE.users[0].id
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! NSDictionary
        self.title = Constants.Services.UTILITY_SERVICE.exist(field: Event.kTitle, dictionary: snapshotValue)
        self.id = snapshot.key
        self.description = Constants.Services.UTILITY_SERVICE.exist(field: Event.kDescription, dictionary: snapshotValue)
        self.date = Constants.Services.UTILITY_SERVICE.exist(field: Event.kDate, dictionary: snapshotValue)
        self.endDate = Constants.Services.UTILITY_SERVICE.exist(field: Event.kEndDate, dictionary: snapshotValue )
        self.priority = Constants.Services.UTILITY_SERVICE.exist(field: Event.kPriority, dictionary: snapshotValue )
        self.reminder = Constants.Services.UTILITY_SERVICE.exist(field: Event.kreminder, dictionary: snapshotValue)
        self.members = Constants.Services.UTILITY_SERVICE.exist(field: Event.kMembers, dictionary: snapshotValue)
        self.location = Location(snapshot: Constants.Services.UTILITY_SERVICE.exist(field: Event.klocation, dictionary: snapshotValue))
        self.creator = Constants.Services.UTILITY_SERVICE.exist(field: Event.kcreator, dictionary: snapshotValue)
    }
 
    func toDictionary() -> NSDictionary {
        
        return [
            Event.kTitle : self.title,
            Event.kDescription : self.description,
            Event.kEndDate : self.endDate,
            Event.kDate : self.date,
            Event.kPriority : self.priority,
            Event.kMembers : Constants.Services.UTILITY_SERVICE.toDictionary(array: self.members),
            Event.kreminder : self.reminder ?? "",
            Event.klocation : self.location?.toDictionary() ?? "",
            Event.kcreator : self.creator
        ]
    }
    
    
    
    
}

protocol EventBindable: AnyObject {
    var event: Event? { get set }
    var descriptionLabel: UILabel! {get}
    var dateLabel: UILabel! {get}
    var endDateLabel: UILabel! {get}
    var locationLabel: UILabel! {get}
    var titleLabel: UILabel! {get}
    var remimberLabel: UILabel! {get}
    
}

extension EventBindable {
    // Make the views optionals
    
    var dateLabel: UILabel! {
        return nil
    }
    
    var endDateLabel: UILabel! {
        return nil
    }
    
    var locationLabel: UILabel! {
        return nil
    }
    var titleLabel: UILabel! {
        return nil
    }
    var descriptionLabel: UILabel! {
        return nil
    }
    
    var reminderLabel: UILabel! {
        return nil
    }
    
    // Bind
    
    func bind(event: Event) {
        self.event = event
        bind()
    }
    
    func bind() {
        
        guard let event = self.event else {
            return
        }
        
        if let locationLabel = self.locationLabel {
            locationLabel.text =  (event.location?.title.isEmpty)! ?  "Sin ubicación" : "\(event.location?.title ?? ""), \(event.location?.subtitle ?? "")"
        }
        
        if let endDateLabel = self.endDateLabel {
            endDateLabel.text = Date(string: event.endDate, formatter: .InternationalFormat)?.string(with: .hourAndMin)
        }
        
        if let titleLabel = self.titleLabel {
            titleLabel.text = event.title
        }
        if let descriptionLabel = self.descriptionLabel {
            descriptionLabel.text = event.description
        }
        
        if let dateLabel = self.dateLabel {
            dateLabel.text =  Date(string: event.date, formatter: .InternationalFormat)?.string(with: .hourAndMin)
        }
        if let reminderLabel = self.remimberLabel {
            reminderLabel.text = event.reminder
        }
        
    }
}


