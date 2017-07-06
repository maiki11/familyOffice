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
    let basePath = "goals/\(service.USER_SERVICE.users[0].id!)"
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
            //self.add(value: snapshot)
            break
        default:
            break
        }
    }
    
    func initObserves(ref: String, actions: [FIRDataEventType]) -> Void {
        for action in actions {
            if !handles.contains(where: { $0.0 == ref}){
                 self.child_action(ref: ref, action: action)
            }
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
        
        store.state.GoalsState.status = .finished
        
    }
    
    func delete(_ ref: String, callback: @escaping ((Any) -> Void)) {
    }
    
    
}
extension GoalService: repository {
    
    func added(snapshot: FirebaseDatabase.FIRDataSnapshot) {
        let id = snapshot.ref.description().components(separatedBy: "/")[4]
        let goal = Goal(snapshot: snapshot)
        
        if (store.state.GoalsState.goals[id] == nil) {
           store.state.GoalsState.goals[id] = []
        }
       
        if !(store.state.GoalsState.goals[id]?.contains(where: {$0.id == goal.id}))!{
            store.state.GoalsState.goals[id]?.append(goal)
        }
    }
    
    func getPath(type: Int) -> String {
        if type == 0 {
            return service.USER_SERVICE.users[0].id!
        }else{
            return service.USER_SERVICE.users[0].familyActive!
        }
    }
    
    func updated(snapshot: FirebaseDatabase.FIRDataSnapshot, id: Any) {
        let id = snapshot.ref.description().components(separatedBy: "/")[4]
        let goal = Goal(snapshot: snapshot)
        if let index = store.state.GoalsState.goals[id]?.index(where: {$0.id == snapshot.key})  {
            store.state.GoalsState.goals[id]?[index] = goal
        }
    }
    
    func removed(snapshot: FirebaseDatabase.FIRDataSnapshot) {
        let id = snapshot.ref.description().components(separatedBy: "/")[4]
        if let index = store.state.GoalsState.goals[id]?.index(where: {$0.id == snapshot.key})  {
            store.state.GoalsState.goals[id]?.remove(at: index)
        }
    }
}
