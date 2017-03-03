//
//  refHandle.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 28/02/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import Firebase

class RefHandle {
    var listeners : [String:UInt] = [:]
    private init(){
    }
    public static func Instance() -> RefHandle{
        return instance
    }
    private static let instance : RefHandle = RefHandle()
    
    func chilAdded(ref: String) -> Void {
        let handle = REF.child(ref).observe(.childAdded, with: {(snapshot) in
            if(snapshot.exists()){
                self.handle(snapshot: snapshot, action: "added", ref: ref)
            }
        }, withCancel: {(error) in
            print(error.localizedDescription)
        })
        listeners[String(NSDate().timeIntervalSince1970)+"+"+ref] = handle
        print(ref , handle)
    }
    
    func chilRemoved(ref: String) -> Void {
        let handle = REF.child(ref).observe(.childRemoved, with: {(snapshot) in
            if(snapshot.exists()){
                self.handle(snapshot: snapshot, action: "removed", ref: ref)
            }
        }, withCancel: {(error) in
            print(error.localizedDescription)
        })
        listeners[String(NSDate().timeIntervalSince1970)+"+"+ref] = handle
        print(ref , handle)
    }
    
    func value(ref: String) -> Void {
        let handle = REF.child(ref).observe(.value, with: {(snapshot) in
            if snapshot.exists(){
                self.handle(snapshot: snapshot, action: "value", ref: ref)
            }
        }, withCancel: {(error) in
            print(error.localizedDescription)
        })
        listeners[String(NSDate().timeIntervalSince1970)+"+"+ref] = handle
        
    }
    func valueSingleton(ref: String) -> Void {
        REF.child(ref).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists(){
                self.handle(snapshot: snapshot, action: "valueS", ref: ref)
            }
        }, withCancel: {(error) in
            print(error.localizedDescription)
        })
    }
    
    func handle(snapshot: FIRDataSnapshot, action: String, ref: String) -> Void {
        print(ref)
        print("REFERENCE COUNT ADD \(listeners.count)")
        let reference : [String] = ref.characters.split(separator: "/").map(String.init)
        switch ref {
            case "users/\(reference[1])":
                if snapshot.exists() {
                    USER_SERVICE.addUser(user: User(snapshot: snapshot))
                    remove(ref: ref)
                //Veifico si el que esta buscando es el que se logeo y no tiene cuneta para que se la cree
                }else if (reference[1] == FIRAuth.auth()?.currentUser?.uid) {
                    AUTH_SERVICE.createAccount(user: (FIRAuth.auth()?.currentUser)!)
                }
                break
            case "users/\((FIRAuth.auth()?.currentUser?.uid)!)/families":
                if action == "added" {
                    self.valueSingleton(ref: "families/\(snapshot.key)")
                }else if action == "removed" {
                    FAMILY_SERVICE.removeFamily(key: snapshot.key)
                }
            break
            case "families/\(reference[1])":
                switch action {
                case "value":
                    FAMILY_SERVICE.addFamily(family: Family(snapshot: snapshot))
                    remove(ref: ref)
                case "valueS":
                    FAMILY_SERVICE.addFamily(family: Family(snapshot: snapshot))
                    break
                default: break
                }
                break
            case "families/\(reference[1])/members":
                if action == "added" {
                    FAMILY_SERVICE.addMember(member: snapshot.key, family: reference[1])
                }else if action == "removed" {
                    FAMILY_SERVICE.removeMember(member: snapshot.key, familyId: reference[1])
                }
                break
            case "notifications/\(reference[1])":
                if action == "added" {
                    NOTIFICATION_SERVICE.add(notification: NotificationModel(snapshot: snapshot))
                }
                break
            case "activityLog/\(reference[1])":
                if action == "added" {
                    ACTIVITYLOG_SERVICE.add(record: Record(snapshot: snapshot))
                }
                break
            default:
                break
        }
    }
    
    func remove(ref: String) -> Void {
       
        for value in listeners.keys {
            let filter = value.characters.split(separator: "+").map(String.init)
            if filter[1] == ref {
                REF.child(ref).removeObserver(withHandle: listeners[value]!)
                listeners.removeValue(forKey: value)
                print("REFERENCE DELETED: \(REF,ref)")
                print("REFERENCE COUNT DEL \(listeners.count)")
            }
        }
        
       
        
    }

}
