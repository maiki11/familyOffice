//
//  HistoryService .swift
//  familyOffice
//
//  Created by Leonardo Durazo on 01/02/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class ActivityLogService {
    public var activityLog : [Record] = []
    
    var handle: UInt!
    private init() {
    }
    
    public static func Instance() -> ActivityLogService {
        return instance
    }
    
    private static let instance : ActivityLogService = ActivityLogService()
    
    func create(id: String, activity: String, photo:String, type: String ) -> Void {
        let key = REF_ACTIVITY.child(id).childByAutoId().key
        let record = Record(id: key, activity: activity, timestamp: Utility.Instance().getDate(), type: type, photoURL: photo)
        REF_ACTIVITY.child("\(id)/\(key)").setValue(record.toDictionary())
        activityLog.append(record)
    }
    func add(record: Record) -> Void {
        if !self.activityLog.contains(where: {$0.id == record.id}){
            self.activityLog.append(record)
            NotificationCenter.default.post(name: SUCCESS_NOTIFICATION, object: record)
        }
    }
}
