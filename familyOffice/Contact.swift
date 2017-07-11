//
//  contact.swift
//  familyOffice
//
//  Created by Miguel Reina on 06/01/17.
//  Copyright © 2017 Miguel Reina. All rights reserved.
//

import Foundation
import Firebase

struct Contact  {
    
    static let kContactIdKey = "id"
    static let kContactNameKey = "name"
    static let kContactPhoneKey = "phone"
    static let kContactJobKey = "job"
    
    let id: String!
    var name: String!
    var phone: String?
    var job : String?
    let firebaseReference: FIRDatabaseReference?
    
    /* Initializer for instantiating a new object in code.
     */
    init(name: String, phone: String, job: String, id: String){
        self.name = name
        self.phone = phone
        self.job = job
        self.firebaseReference = nil
        self.id = id
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! NSDictionary
        self.id = snapshot.key
        self.name = service.UTILITY_SERVICE.exist(field: Contact.kContactNameKey, dictionary: snapshotValue)
        self.phone = service.UTILITY_SERVICE.exist(field: Contact.kContactPhoneKey, dictionary: snapshotValue)
        self.job = service.UTILITY_SERVICE.exist(field: Contact.kContactJobKey, dictionary: snapshotValue)
        self.firebaseReference = snapshot.ref
    }
 
    /* Method to help updating values of an existing object.
     */
    func toDictionary() -> Any {
        
        return [
            Contact.kContactNameKey: self.name,
            Contact.kContactPhoneKey: self.phone,
            Contact.kContactJobKey : self.job
        ]
    }
   /*
    mutating func update(snapshot: FIRDataSnapshot){
        guard let value = snapshot.value! as? NSDictionary else {
            return
        }
        
        switch snapshot.key {
        case  Family.kFamilyNameKey:
            self.name =  snapshot.value! as! String
            break
        case Family.kFamilyMembersKey:
            self.members = service.UTILITY_SERVICE.exist(field: Family.kFamilyMembersKey, dictionary: value)
            break
        case Family.kFamilyPhotoUrlKey:
            self.photoURL = snapshot.value as? String
            break
        default:
            break
        }
    }*/
    
}
