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
    

    func inserted(ref: FIRDatabaseReference) -> Void
    
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
    
}
