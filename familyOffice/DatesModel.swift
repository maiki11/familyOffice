//
//  DatesModel.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 23/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
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

protocol DateModelBindable: AnyObject {
    var dateModel: DateModel? { get set }
    
    var dateLabel: UILabel! {get}
    var endDateLabel: UILabel! {get}
    var locationLabel: UILabel! {get}
    var titleLabel: UILabel! {get}
    
}

extension DateModelBindable {
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
    
    var collectionView: UICollectionView! {
        return nil
    }
    
    // Bind
    
    func bind(dateModel: DateModel) {
        self.dateModel = dateModel
        bind()
    }
    
    func bind() {
        
        guard let dateModel = self.dateModel else {
            return
        }
        
        if let locationLabel = self.locationLabel {
            locationLabel.text = "Sin ubicación"
        }
        
        if let endDateLabel = self.endDateLabel {
            endDateLabel.text = Date(string: dateModel.endDate, formatter: .dayMonthYearHourMinute)?.string(with: .hourAndMin)
        }
        
        if let titleLabel = self.titleLabel {
            titleLabel.text = dateModel.title
        }
        
        if let dateLabel = self.dateLabel {
            dateLabel.text =  Date(string: dateModel.date, formatter: .dayMonthYearHourMinute)?.string(with: .hourAndMin)
        }
        
    }
}


