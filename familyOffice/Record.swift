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
    static let utilityService = Utility.Instance()
    
    static let kRecordIdkey = "id"
    static let kRecordActivykey = "action"
    static let kRecordDatekey = "date"
    static let kRecordPhotokey = "photo"
    static let kRecordTypekey = "type"
    
    let id: String!
    let activity: String!
    let date: String!
    let type: String!
    var photoURL: String!
    
    init(id: String, activity: String, date: String, type: String, photoURL: String) {
        
        self.activity = activity
        self.date = date
        self.id = id
        self.photoURL = photoURL
        self.type = type
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! NSDictionary
        self.id = snapshot.key
        self.activity = Record.utilityService.exist(field: Record.kRecordActivykey, dictionary: snapshotValue)
        self.date = Record.utilityService.exist(field: Record.kRecordDatekey, dictionary: snapshotValue)
        self.type = Record.utilityService.exist(field: Record.kRecordTypekey, dictionary: snapshotValue)
        self.photoURL = Record.utilityService.exist(field: Record.kRecordPhotokey, dictionary: snapshotValue)

    }
    func toDictionary() -> NSDictionary {
        return [
            Record.kRecordDatekey : self.date,
            Record.kRecordActivykey : self.activity,
            Record.kRecordPhotokey : self.photoURL,
            Record.kRecordTypekey : self.type
        ]
    }
    
    
}
