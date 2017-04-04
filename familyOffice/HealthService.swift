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
    
    public func addedMed(snapshot: FIRDataSnapshot, uid: String){
        let med = Health.Med(snapshot: snapshot)
        if let userIndex = USER_SERVICE.users.index(where: {$0.id == uid}) {
            let medIndex = Int(snapshot.key)
            if medIndex! >= USER_SERVICE.users[userIndex].health.meds.count {
                USER_SERVICE.users[userIndex].health.meds.append(med)
            }else{
                USER_SERVICE.users[userIndex].health.meds[medIndex!] = med
            }
            USER_SERVICE.users[userIndex].health.meds.append(med)
            NotificationCenter.default.post(name: HEALTHMED_ADDED, object: med)
        }
    }
    
    public func updatedMed(snapshot: FIRDataSnapshot, uid: String){
        let med = Health.Med(snapshot: snapshot)
        if let userIndex = USER_SERVICE.users.index(where: {$0.id == uid}) {
            let index = Int(snapshot.key)
            USER_SERVICE.users[userIndex].health.meds[index!] = med
            NotificationCenter.default.post(name: HEALTHMED_UPDATED, object: med)
        }
    }
    
    public func removedMed(snapshot: FIRDataSnapshot, uid: String){
        if let userIndex = USER_SERVICE.users.index(where: {$0.id == uid}) {
            let index = Int(snapshot.key)
            USER_SERVICE.users[userIndex].health.meds.remove(at: index!)
            NotificationCenter.default.post(name: HEALTHMED_REMOVED, object: nil)
        }
    }
    
    public func addedDisease(snapshot: FIRDataSnapshot, uid: String){
        let disease = Health.Disease(snapshot: snapshot)
        if let userIndex = USER_SERVICE.users.index(where: {$0.id == uid}) {
            let medIndex = Int(snapshot.key)
            if medIndex! >= USER_SERVICE.users[userIndex].health.diseases.count {
                USER_SERVICE.users[userIndex].health.diseases.append(disease)
            }else{ // called at first, just update
                USER_SERVICE.users[userIndex].health.diseases[medIndex!] = disease
            }
            NotificationCenter.default.post(name: HEALTHDISEASE_ADDED, object: disease)
        }

    }
    
    public func updatedDisease(snapshot: FIRDataSnapshot, uid: String){
        let disease = Health.Disease(snapshot: snapshot)
        if let userIndex = USER_SERVICE.users.index(where: {$0.id == uid}) {
            let medIndex = Int(snapshot.key)
            USER_SERVICE.users[userIndex].health.diseases[medIndex!] = disease
            NotificationCenter.default.post(name: HEALTHDISEASE_UPDATED, object: disease)
        }
    }
    
    public func removedDisease(snapshot: FIRDataSnapshot, uid: String){
        if let userIndex = USER_SERVICE.users.index(where: {$0.id == uid}) {
            let medIndex = Int(snapshot.key)
            if medIndex! < USER_SERVICE.users[userIndex].health.diseases.count {
                USER_SERVICE.users[userIndex].health.diseases.remove(at: medIndex!)
            }
            NotificationCenter.default.post(name: HEALTHDISEASE_REMOVED, object: nil)
        }
    }
    
    public func addedDoctor(snapshot: FIRDataSnapshot, uid: String){
        let model = Health.Doctor(snapshot: snapshot)
        if let userIndex = USER_SERVICE.users.index(where: {$0.id == uid}) {
            let modelIndex = Int(snapshot.key)
            if modelIndex! == USER_SERVICE.users[userIndex].health.doctors.count {
                USER_SERVICE.users[userIndex].health.doctors.append(model)
            }else{ // called at first, just update
                USER_SERVICE.users[userIndex].health.doctors[modelIndex!] = model
            }
            NotificationCenter.default.post(name: HEALTHDOCTOR_ADDED, object: model)
        }
    }
    
    public func updatedDoctor(snapshot: FIRDataSnapshot, uid: String){
        let model = Health.Doctor(snapshot: snapshot)
        if let userIndex = USER_SERVICE.users.index(where: {$0.id == uid}) {
            let modelIndex = Int(snapshot.key)
            USER_SERVICE.users[userIndex].health.doctors[modelIndex!] = model
            NotificationCenter.default.post(name: HEALTHDOCTOR_UPDATED, object: model)
        }
    }
    
    public func removedDoctor(snapshot: FIRDataSnapshot, uid: String){
        if let userIndex = USER_SERVICE.users.index(where: {$0.id == uid}) {
            let modelIndex = Int(snapshot.key)
            if modelIndex! < USER_SERVICE.users[userIndex].health.doctors.count {
                USER_SERVICE.users[userIndex].health.doctors.remove(at: modelIndex!)
            }
            NotificationCenter.default.post(name: HEALTHDOCTOR_REMOVED, object: nil)
        }
    }
    
    public func addedOperation(snapshot: FIRDataSnapshot, uid: String){
        let model = Health.Operation(snapshot: snapshot)
        if let userIndex = USER_SERVICE.users.index(where: {$0.id == uid}) {
            let modelIndex = Int(snapshot.key)
            if modelIndex! == USER_SERVICE.users[userIndex].health.operations.count {
                USER_SERVICE.users[userIndex].health.operations.append(model)
            }else{ // called at first, just update
                USER_SERVICE.users[userIndex].health.operations[modelIndex!] = model
            }
            NotificationCenter.default.post(name: HEALTHOPERATION_ADDED, object: model)
        }
    }
    
    public func updatedOperation(snapshot: FIRDataSnapshot, uid: String){
        let model = Health.Operation(snapshot: snapshot)
        if let userIndex = USER_SERVICE.users.index(where: {$0.id == uid}) {
            let modelIndex = Int(snapshot.key)
            USER_SERVICE.users[userIndex].health.operations[modelIndex!] = model
            NotificationCenter.default.post(name: HEALTHOPERATION_UPDATED, object: model)
        }
    }
    
    public func removedOperation(snapshot: FIRDataSnapshot, uid: String){
        if let userIndex = USER_SERVICE.users.index(where: {$0.id == uid}) {
            let modelIndex = Int(snapshot.key)
            if modelIndex! < USER_SERVICE.users[userIndex].health.operations.count {
                USER_SERVICE.users[userIndex].health.operations.remove(at: modelIndex!)
            }
            NotificationCenter.default.post(name: HEALTHOPERATION_REMOVED, object: nil)
        }
    }
    
}
