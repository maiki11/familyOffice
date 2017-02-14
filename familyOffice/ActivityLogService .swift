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
    
    func getActivities(id: String) {
        REF_ACTIVITY.child(id).queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value, with: { (snapshot) in
            self.activityLog = []
            if(snapshot.exists()){
                for item in snapshot.children{
                    self.activityLog.append(Record(snapshot: item as! FIRDataSnapshot))
                }
                NotificationCenter.default.post(name: SUCCESS_NOTIFICATION, object: nil)
            }
        })
    }
}
