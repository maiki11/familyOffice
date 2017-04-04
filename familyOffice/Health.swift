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
    
    var meds: [Med]
    var diseases: [Disease]
    var doctors: [Doctor]
    var operations: [Operation]
    
    init(health: NSDictionary){
        let medArray = health[Health.kHealthMeds] as? [NSDictionary] ?? []
        self.meds = medArray.map({m in return Med(dic: m)})
    	let diseaseArray = health[Health.kHealthDiseases] as? [NSDictionary] ?? []
        self.diseases = diseaseArray.map({d in return Disease(dic: d)})
        let doctorArray = health[Health.kHealthDoctors] as? [NSDictionary] ?? []
        self.doctors = doctorArray.map({d in return Doctor(dic: d)})
        let operationArray = health[Health.kHealthOperations] as? [NSDictionary] ?? []
        self.operations = operationArray.map({o in return Operation(dic: o)})
    }
    
    init(meds: [Med], diseases: [Disease], doctors: [Doctor], operations: [Operation]){
        self.meds = meds;
        self.diseases = diseases;
        self.doctors = doctors;
        self.operations = operations;
    }
    
    init(snapshot: FIRDataSnapshot){
        let snapDic = snapshot.value as? NSDictionary
        self.init(health: snapDic ?? [:])
    }
    
    func toDictionary() -> NSDictionary {
        return [
            Health.kHealthMeds: self.meds.map({m in return m.toDictionary()}),
            Health.kHealthDiseases: self.diseases.map({d in return d.toDictionary()}),
            Health.kHealthDoctors: self.doctors.map({d in return d.toDictionary()}),
            Health.kHealthOperations: self.operations.map({o in return o.toDictionary()})
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
        
        var name: String
        var type: String
        var dose: String
        var lapse: Int
        
        init(name: String, type: String, dose: String, lapse: Int){
            self.name = name
            self.type = type
            self.dose = dose
            self.lapse = lapse
        }
        
        init(dic: NSDictionary){
            self.name = UTILITY_SERVICE.exist(field: Health.Med.kMedName, dictionary: dic)
            self.type = UTILITY_SERVICE.exist(field: Health.Med.kMedType, dictionary: dic)
            self.dose = UTILITY_SERVICE.exist(field: Health.Med.kMedDose, dictionary: dic)
            self.lapse = dic[Health.Med.kMedLapse] as! Int
        }
        
        init(snapshot: FIRDataSnapshot){
            let snapDic = snapshot.value as! NSDictionary
            self.init(dic: snapDic)
        }
        
        func toDictionary() -> NSDictionary {
            return [
                Med.kMedName : self.name,
                Med.kMedType : self.type,
                Med.kMedDose : self.dose,
                Med.kMedLapse: self.lapse
            ]
        }
    }
    
    struct Disease {
    	static let kDiseaseName = "name"
        
        var name: String
        
        init(name: String){
            self.name = name
        }
        
        init(dic: NSDictionary){
            self.name = UTILITY_SERVICE.exist(field: Disease.kDiseaseName, dictionary: dic)
        }
        
        init(snapshot: FIRDataSnapshot){
            let snapDic = snapshot.value as! NSDictionary
            self.init(dic: snapDic)
        }
        
        func toDictionary() -> NSDictionary {
            return [
                Disease.kDiseaseName: self.name
            ]
        }
    }
    
    struct Doctor {
    	static let kDoctorName = "name"
        static let kDoctorPhone = "phone"
        static let kDoctorAddress = "address"
        
        var name: String
        var phone: String
        var address: String
        
        init(dic: NSDictionary){
            self.name = dic[Doctor.kDoctorName] as! String
            self.phone = dic[Doctor.kDoctorPhone] as! String
            self.address = dic[Doctor.kDoctorAddress] as! String
        }
        
        init(name: String, phone: String, address: String){
            self.name = name
            self.phone = phone
            self.address = address
        }
        
        init(snapshot: FIRDataSnapshot){
            let snapDic = snapshot.value as! NSDictionary
            self.name = UTILITY_SERVICE.exist(field: Doctor.kDoctorName, dictionary: snapDic)
            self.phone = UTILITY_SERVICE.exist(field: Doctor.kDoctorPhone, dictionary: snapDic)
            self.address = UTILITY_SERVICE.exist(field: Doctor.kDoctorAddress, dictionary: snapDic)
        }
        
        func toDictionary() -> NSDictionary {
            return [
                Doctor.kDoctorName: self.name,
                Doctor.kDoctorPhone: self.phone,
                Doctor.kDoctorAddress: self.address
            ]
        }

    }
    
    
    struct Operation {
    	static let kOperationDescription = "description"
        static let kOperationDate = "date"
        
        var description: String
        var date: Date
        
        init(dic: NSDictionary){
            self.description = dic[Operation.kOperationDescription] as! String
            self.date = Date(timeIntervalSince1970: dic[Operation.kOperationDate] as! TimeInterval)
        }
        
        init(description: String, date: Date){
            self.description = description
            self.date = date
        }
        
        init(snapshot: FIRDataSnapshot){
            let dic = snapshot.value as! NSDictionary
            self.init(dic: dic)
        }
        
        func toDictionary() -> NSDictionary {
            return [
                Operation.kOperationDescription: self.description,
                Operation.kOperationDate: self.date.timeIntervalSince1970
            ]
        }
    }
}
