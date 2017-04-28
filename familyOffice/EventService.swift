//
//  Event.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 24/04/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Firebase
class EventService: RequestService {
    public var events: [Event] = []
    
    private init(){
    }
    public static func Instance() -> EventService {
        return instance
    }
    
    private static let instance : EventService = EventService()
    
    
    func insert(_ ref: String, value: Any, callback: @escaping ((Any) -> Void)) {
        Constants.FirDatabase.REF.child(ref).setValue(value as! NSDictionary, withCompletionBlock: {(error, ref) in
       
            
            if error != nil {
                print(error.debugDescription)
            }else {
                DispatchQueue.main.async {
                    Constants.Services.USER_SERVICE.users[0].events?.append(ref.key)
                    self.addEventToMember(uid: Constants.Services.USER_SERVICE.users[0].id, eid: ref.key)
                    callback(ref.key)
                }
            }
            
           
        })
        
    }
    func addEventlocal(snapshot: FIRDataSnapshot) -> Void {
        let event = Event.init(snapshot: snapshot)
        if !events.contains(where: {$0.id == event.id}){
            events.append(event)
            NotificationCenter.default.post(name: Constants.NotificationCenter.SUCCESS_NOTIFICATION, object: event.id)
        }
    }
    func addEventToMember(uid: String, eid: String) {
        Constants.FirDatabase.REF_USERS.child("\(uid)/events").updateChildValues([eid:true])
    }
    
    func delete(_ ref: String, callback: @escaping ((Any) -> Void)) {
        
    }
    
    func update(_ ref: String, value: [AnyHashable : Any], callback: @escaping ((Any) -> Void)) {
        
    }
}
