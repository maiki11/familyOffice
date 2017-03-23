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
    
    var meds: [NSDictionary]! //ids
    var diseases: [NSDictionary]!
    var doctors: [NSDictionary]!
    var operations: [NSDictionary]!
    
    struct Operation {}
    
    init(meds: [NSDictionary], diseases: [NSDictionary], doctors: [NSDictionary], operations: [NSDictionary]){
        self.meds = meds;
        self.diseases = diseases;
        self.doctors = doctors;
        self.operations = operations;
    }
    
    init(snapshot: FIRDataSnapshot){
        let snapDic = snapshot.value as! NSDictionary
        self.meds = UTILITY_SERVICE.existArray(field: Health.kHealthMeds, dictionary: snapDic) as! [NSDictionary]
        self.diseases = UTILITY_SERVICE.existArray(field: Health.kHealthDiseases, dictionary: snapDic) as! [NSDictionary]
        self.doctors = UTILITY_SERVICE.existArray(field: Health.kHealthDoctors, dictionary: snapDic) as! [NSDictionary]
        self.operations = UTILITY_SERVICE.existArray(field: Health.kHealthOperations, dictionary: snapDic) as! [NSDictionary]
        
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

extension Health {
    struct Med {
        static let kMedName = "name"
        static let kMedType = "type"
        static let kMedDose = "dose"
        static let kMedLapse = "lapse"
        
        var name: String!
        var type: String!
        var dose: String!
        var lapse: Int64!
        
        init(name: String, type: String, dose: String, lapse: Int64){
            self.name = name
            self.type = type
            self.dose = dose
            self.lapse = lapse
        }
        
        init(snapshot: FIRDataSnapshot){
            let snapDic = snapshot.value as! NSDictionary
            self.name = UTILITY_SERVICE.exist(field: Health.Med.kMedName, dictionary: snapDic)
            self.type = UTILITY_SERVICE.exist(field: Health.Med.kMedType, dictionary: snapDic)
            self.dose = UTILITY_SERVICE.exist(field: Health.Med.kMedDose, dictionary: snapDic)
            self.lapse = Int64(UTILITY_SERVICE.exist(field: Health.Med.kMedLapse, dictionary: snapDic))
        }
    }
    
    struct Disease {
    	static let kDiseaseName = "name"
        
        var name: String!
        
        init(name: String){
            self.name = name
        }
        
        init(snapshot: FIRDataSnapshot){
            let snapDic = snapshot.value as! NSDictionary
            self.name = UTILITY_SERVICE.exist(field: Disease.kDiseaseName, dictionary: snapDic)
        }
    }
    
    struct Doctor {
    	static let kDoctorName = "name"
        
        var name: String!
        
        init(name: String){
            self.name = name
        }
        
        init(snapshot: FIRDataSnapshot){
            let snapDic = snapshot.value as! NSDictionary
            self.name = UTILITY_SERVICE.exist(field: Doctor.kDoctorName, dictionary: snapDic)
        }
    }
}
