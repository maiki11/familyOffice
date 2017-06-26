//
//  Notification.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 15/02/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import Firebase
struct NotificationModel {
    
    static let kNotificationIdkey = "id"
    static let kNotificationTitlekey = "title"
    static let kNotificationDatekey = "timestamp"
    static let kNotificationPhotokey = "photo"
    static let kNotificationSeenkey = "seen"
    
    let id: String!
    let title: String!
    let timestamp: Double!
    var seen: Bool!
    var photoURL: String!
    
    init(id: String, title: String, timestamp: Double, photoURL: String) {
        self.title = title
        self.timestamp = timestamp * -1
        self.id = id
        self.photoURL = photoURL
        self.seen = false
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! NSDictionary
        self.id = snapshot.key
        self.title = service.UTILITY_SERVICE.exist(field: NotificationModel.kNotificationTitlekey, dictionary: snapshotValue)
        self.timestamp = service.UTILITY_SERVICE.exist(field: NotificationModel.kNotificationDatekey, dictionary: snapshotValue)
        self.seen = snapshotValue.object(forKey: "seen") as! Bool
        self.photoURL = service.UTILITY_SERVICE.exist(field: NotificationModel.kNotificationPhotokey, dictionary: snapshotValue)
        
    }
    func toDictionary() -> NSDictionary {
        return [
            NotificationModel.kNotificationDatekey : self.timestamp,
            NotificationModel.kNotificationTitlekey : self.title,
            NotificationModel.kNotificationPhotokey : self.photoURL,
            NotificationModel.kNotificationSeenkey : self.seen
        ]
    }
    
    
    
}
