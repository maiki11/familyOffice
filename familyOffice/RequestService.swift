//
//  RequestService.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 07/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import Toast_Swift

class RequestService {
    
    var proccess : [Proccess] = []
    
    
    private static let instance : RequestService = RequestService()
    private init(){
    }
    public static func Instance() -> RequestService {
        return instance
    }
    
    func insert(value: NSDictionary, ref: String) -> Void{

        //proccess.append(Proccess(text: "Insertando", status: "En Proceso", type: "Insertando"))
        Constants.FirDatabase.REF.child(ref).setValue(value, withCompletionBlock: {(error, reference) in
          
            if error != nil {
           
                NotificationCenter.default.post(name: Constants.NotificationCenter.ERROR_NOTIFICATION, object: nil)
            }
            NotificationCenter.default.post(name: Constants.NotificationCenter.SUCCESS_NOTIFICATION, object: value)
           

        })
    }
    
    func delete(ref: String) -> Void {
        Constants.FirDatabase.REF.child(ref).removeValue(completionBlock: {(error, reference) in
            if error != nil {
                NotificationCenter.default.post(name: Constants.NotificationCenter.ERROR_NOTIFICATION, object: nil)
            }
            NotificationCenter.default.post(name: Constants.NotificationCenter.SUCCESS_NOTIFICATION, object: ref.characters.split(separator: "/").last )
        })
    }
    
    func update(value:  [AnyHashable : Any], ref: String) -> Void {
        Constants.FirDatabase.REF.child(ref).updateChildValues(value, withCompletionBlock: {(error, ref) in
            if error != nil {
                NotificationCenter.default.post(name: Constants.NotificationCenter.ERROR_NOTIFICATION, object: nil)
            }
            NotificationCenter.default.post(name: Constants.NotificationCenter.SUCCESS_NOTIFICATION, object: nil )

        })
    }
    
    
}
