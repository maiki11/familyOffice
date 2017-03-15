//
//  Health.swift
//  familyOffice
//
//  Created by Nan Montaño on 14/mar/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import Firebase

struct Health {
    
    static let kHealthMeds = "meds";
    static let kHealthDiseases = "diseases";
    static let kHealthDoctors = "doctors";
    static let kHealthOperations = "operations";
    
    var meds: [String]! //ids
    var diseases: [String]!
    var doctors: [String]!
    var operations: [String]!
    
    init(meds: [String], diseases: [String], doctors: [String], operations: [String]){
        self.meds = meds;
        self.diseases = diseases;
        self.doctors = doctors;
        self.operations = operations;
    }
    
    init(snapshot: FIRDataSnapshot){
        let snapshotValue = snapshot.value as! NSDictionary
        self.meds = UTILITY_SERVICE.existArray(field: Health.kHealthMeds, dictionary: snapshotValue) as! [String]
        self.diseases = UTILITY_SERVICE.existArray(field: Health.kHealthDiseases, dictionary: snapshotValue) as! [String]
        self.doctors = UTILITY_SERVICE.existArray(field: Health.kHealthDoctors, dictionary: snapshotValue) as! [String]
        self.operations = UTILITY_SERVICE.existArray(field: Health.kHealthOperations, dictionary: snapshotValue) as! [String]
    }
    
    func toDictionary() -> NSDictionary {
        return [
            Health.kHealthMeds: self.meds,
            Health.kHealthDiseases: self.diseases,
            Health.kHealthDoctors: self.doctors,
            Health.kHealthOperations: self.operations
        ]
    }
    
    mutating func update(snapshot: FIRDataSnapshot){
//        switch snapshot.key {
//            
//        }
    }
}
