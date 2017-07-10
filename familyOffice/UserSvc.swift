//
//  UserSvc.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 09/07/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import Firebase
class UserSvc {
    var handles: [(String, UInt, FIRDataEventType)]
    
    private init(){
    }
    public static func Instance() -> UserSvc {
        return instance
    }
    func initObserves(ref: String, actions: [FIRDataEventType]) -> Void {
        for action in actions {
            if !handles.contains(where: { $0.0 == ref && $0.2 == action} ){
                self.child_action(ref: ref, action: action)
            }
        }
    }
    
    private static let instance : UserSvc = UserSvc()
}
extension UserSvc : RequestService {
    func addHandle(_ handle: UInt, ref: String, action: FIRDataEventType) {
        self.handles.append((ref,handle,action))
    }
    
    func inserted(ref: FIRDatabaseReference) {
        store.state.UserState.status = .finished
    }
    
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
            self.added(snapshot: snapshot)
            break
        default:
            break
        }
    }
    
    func removeHandles() {
        for handle in self.handles {
            Constants.FirDatabase.REF.child(handle.0).removeObserver(withHandle: handle.1)
        }
        self.handles.removeAll()
    }
    
    func delete(_ ref: String, callback: @escaping ((Any) -> Void)) {
    }
}

extension UserSvc : repository {
    /// Este metodo guarda al usuario, verificando si es el usuario logeado guardandolo en el state UserState.user,
    /// los demas los guarda en UserState.users
    /// - Parameter snapshot: FirDataSnapshot
    func added(snapshot: FIRDataSnapshot) {
        let user = User(snapshot: snapshot)
        if user.id == store.state.UserState.user.id || store.state.UserState.user.id != "" {
            service.NOTIFICATION_SERVICE.saveToken()
            //Get families
            store.state.UserState.user = user
        }else{
            if !store.state.UserState.users.contains(where: {$0.id == user.id}) {
                store.state.UserState.users.append(user)
            }
        }
    }
    func updated(snapshot: FIRDataSnapshot, id: Any) {
        
    }
    func removed(snapshot: FIRDataSnapshot) {
        
    }
}
