//
//  HealthService.swift
//  familyOffice
//
//  Created by Nan Montaño on 29/mar/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import Firebase

class HealthService {
    
    private init() {}
    
    static private let service = HealthService()
    
    public static func Instance() -> HealthService { return service }
    
    public func addedElement(snapshot: FIRDataSnapshot, uid: String){
        let model = Health.Element(snapshot: snapshot)
        if let userIndex = USER_SERVICE.users.index(where: {$0.id == uid}) {
            let modelIndex = Int(snapshot.key)
            if modelIndex! >= USER_SERVICE.users[userIndex].health.elements.count {
                USER_SERVICE.users[userIndex].health.elements.append(model)
            }else{
                USER_SERVICE.users[userIndex].health.elements[modelIndex!] = model
            }
            NotificationCenter.default.post(name: HEALTHELEMENT_ADDED, object: model)
        }
    }
    
    public func updatedElement(snapshot: FIRDataSnapshot, uid: String){
        let model = Health.Element(snapshot: snapshot)
        if let userIndex = USER_SERVICE.users.index(where: {$0.id == uid}) {
            let index = Int(snapshot.key)
            USER_SERVICE.users[userIndex].health.elements[index!] = model
            NotificationCenter.default.post(name: HEALTHELEMENT_UPDATED, object: model)
        }
    }
    
    public func removedElement(snapshot: FIRDataSnapshot, uid: String){
        if let userIndex = USER_SERVICE.users.index(where: {$0.id == uid}) {
            let index = Int(snapshot.key)
            if index! < USER_SERVICE.users[userIndex].health.elements.count {
                USER_SERVICE.users[userIndex].health.elements.remove(at: index!)
            }
            NotificationCenter.default.post(name: HEALTHELEMENT_REMOVED, object: index)
        }
    }
    
    
}
