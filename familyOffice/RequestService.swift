//
//  RequestService.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 07/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Toast_Swift
import Firebase
protocol RequestService {
    
    var handles: [(String,UInt)] {get set}
    func addHandle(_ handle: UInt, ref: String) -> Void
    func removeHandles() -> Void
    func inserted(ref: FIRDatabaseReference) -> Void
    func routing(snapshot: FIRDataSnapshot, action: FIRDataEventType, ref: String) -> Void
    func delete(_ ref: String, callback: @escaping ((_ results: Any) -> Void))
    func update(_ ref: String,value:  [AnyHashable : Any], callback: @escaping ((_ results: Any) -> Void))
    
}
extension RequestService {
    func insert(_ ref: String, value: Any, callback: @escaping ((Any) -> Void)) {
        Constants.FirDatabase.REF.child(ref).setValue(value as! NSDictionary, withCompletionBlock: {(error, ref) in
            if error != nil {
                print(error.debugDescription)
            }else {
                DispatchQueue.main.async {
                    self.inserted(ref: ref)
                    callback(ref as FIRDatabaseReference)
                }
            }
        })
    }
    
    func child_action(ref: String, action: FIRDataEventType) -> Void {
        let handle = Constants.FirDatabase.REF.child(ref).observe(action, with: {(snapshot) in
            if(snapshot.exists()){
                self.routing(snapshot: snapshot, action: action, ref: ref)
            }
        }, withCancel: {(error) in
            print(error.localizedDescription)
        })
        self.addHandle(handle, ref: ref)
    }

    func valueSingleton(ref: String) -> Void {
        Constants.FirDatabase.REF.child(ref).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists(){
                self.routing(snapshot: snapshot, action: FIRDataEventType.value, ref: ref)
            }
        }, withCancel: {(error) in
            print(error.localizedDescription)
        })
    }


}
