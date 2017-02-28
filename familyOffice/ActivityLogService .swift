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
    
    func getActivities()  {
        /*REF_ACTIVITY.child((USER_SERVICE.user?.id)!).observeSingleEvent(of: .value, with: { (snapshot) in
         if(snapshot.exists()){
         for item in snapshot.children {
         let not = Record(snapshot:item as! FIRDataSnapshot)
         if !self.activityLog.contains(where: {$0.id == not.id}){
         self.activityLog.append(not)
         NotificationCenter.default.post(name: SUCCESS_NOTIFICATION, object: not)
         }
         
         }
         }
         })*/
        
        handle = REF_ACTIVITY.child((USER_SERVICE.user?.id)!).queryOrdered(byChild: "timestamp").observe( .childAdded, with: { (snapshot) in
            if(snapshot.exists()){
                let not = Record(snapshot:snapshot)
                if !self.activityLog.contains(where: {$0.id == not.id}){
                    self.activityLog.append(not)
                    NotificationCenter.default.post(name: SUCCESS_NOTIFICATION, object: not)
                }
                
            }
        })
    }
}
