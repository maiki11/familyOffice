//
//  GoalService.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 23/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import FirebaseDatabase
let defaults = UserDefaults.standard
class GoalService: RequestService {
    var goals: [Goal] = []
    var handles: [(String,UInt)] = []
    let basePath = "events/\(service.USER_SERVICE.users[0].id)"
    private init() {}
    
    static private let instance = GoalService()
    
    public static func Instance() -> GoalService { return instance }
    
    func routing(snapshot: FIRDataSnapshot, action: FIRDataEventType, ref: String) {
        switch action {
        case .childAdded:
            self.added(snapshot: snapshot)
            break
        case .childRemoved:
            self.removed(snapshot: snapshot)
            break
        case .childChanged:
            self.updated(snapshot: snapshot, id: snapshot.key)
            break
        case .value:
            self.add(value: snapshot)
            break
        default:
            break
        }
    }
    
    func initObserves(ref: String, actions: [FIRDataEventType]) -> Void {
        for action in actions {
            self.child_action(ref: ref, action: action)
        }
    }
    
    func addHandle(_ handle: UInt, ref: String) {
        self.handles.append(ref,handle)
    }
    
    func removeHandles() {
        for handle in self.handles {
            Constants.FirDatabase.REF.child(handle.0).removeObserver(withHandle: handle.1)
        }
        self.handles.removeAll()
    }
    
    func inserted(ref: FIRDatabaseReference) {
        Constants.FirDatabase.REF_USERS.child(service.USER_SERVICE.users[0].id!).child("goals").updateChildValues([ref.key:true])
    }
    
    func delete(_ ref: String, callback: @escaping ((Any) -> Void)) {
    }
    
    func update(_ ref: String, value: [AnyHashable: Any], callback: @escaping ((Any) -> Void)) {
    }
    
    
    
}
extension GoalService: repository {
   
    func added(snapshot: FirebaseDatabase.FIRDataSnapshot) {
        if !goals.contains(where: {$0.id == snapshot.key}){
            self.valueSingleton(ref: "goals/\(service.USER_SERVICE.users[0].id!)/\(snapshot.key)")
        }
    }
    
    func add(value: FIRDataSnapshot) -> Void {
        let goal = Goal(snapshot: value)
        goals.append(goal)
        NotificationCenter.default.post(name: notCenter.SUCCESS_NOTIFICATION, object: goal)
    }
    
    func updated(snapshot: FirebaseDatabase.FIRDataSnapshot, id: Any) {
    }
    
    func removed(snapshot: FirebaseDatabase.FIRDataSnapshot) {
        if let index = goals.index(where: {$0.id == snapshot.key}){
            self.goals.remove(at: index)
            NotificationCenter.default.post(name: notCenter.SUCCESS_NOTIFICATION, object: nil)
        }
    }
}
