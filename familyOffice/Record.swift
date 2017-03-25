//
//  record.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 01/02/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import Firebase

struct Record {
<<<<<<< Updated upstream
    
    static let kRecordIdkey = "id"
    static let kRecordActivykey = "action"
    static let kRecordDatekey = "timestamp"
=======
    static let utilityService = Utility.Instance()
    
    static let kRecordIdkey = "id"
    static let kRecordActivykey = "action"
    static let kRecordDatekey = "date"
>>>>>>> Stashed changes
    static let kRecordPhotokey = "photo"
    static let kRecordTypekey = "type"
    
    let id: String!
    let activity: String!
<<<<<<< Updated upstream
    let timestamp: Double!
    let type: String!
    var photoURL: String!
    
    init(id: String, activity: String, timestamp: Double, type: String, photoURL: String) {
        
        self.activity = activity
        self.timestamp = timestamp * -1
=======
    let date: String!
    let type: String!
    var photoURL: String!
    
    init(id: String, activity: String, date: String, type: String, photoURL: String) {
        
        self.activity = activity
        self.date = date
>>>>>>> Stashed changes
        self.id = id
        self.photoURL = photoURL
        self.type = type
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! NSDictionary
        self.id = snapshot.key
<<<<<<< Updated upstream
        self.activity = UTILITY_SERVICE.exist(field: Record.kRecordActivykey, dictionary: snapshotValue)
        self.timestamp = UTILITY_SERVICE.exist(field: Record.kRecordDatekey, dictionary: snapshotValue)
        self.type = UTILITY_SERVICE.exist(field: Record.kRecordTypekey, dictionary: snapshotValue)
        self.photoURL = UTILITY_SERVICE.exist(field: Record.kRecordPhotokey, dictionary: snapshotValue)
=======
        self.activity = Record.utilityService.exist(field: Record.kRecordActivykey, dictionary: snapshotValue)
        self.date = Record.utilityService.exist(field: Record.kRecordDatekey, dictionary: snapshotValue)
        self.type = Record.utilityService.exist(field: Record.kRecordTypekey, dictionary: snapshotValue)
        self.photoURL = Record.utilityService.exist(field: Record.kRecordPhotokey, dictionary: snapshotValue)
>>>>>>> Stashed changes

    }
    func toDictionary() -> NSDictionary {
        return [
<<<<<<< Updated upstream
            Record.kRecordDatekey : self.timestamp,
=======
            Record.kRecordDatekey : self.date,
>>>>>>> Stashed changes
            Record.kRecordActivykey : self.activity,
            Record.kRecordPhotokey : self.photoURL,
            Record.kRecordTypekey : self.type
        ]
    }
    
    
}
