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
    var job : String!
    let firebaseReference: FIRDatabaseReference?
    
    /* Initializer for instantiating a new object in code.
     */
    init(name: String, phone: String, job: String){
        self.name = name
        self.phone = phone
        self.job = job
        self.firebaseReference = nil
        self.id = Constants.FirDatabase.REF.childByAutoId().key
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
   
    mutating func update(snapshot: FIRDataSnapshot){
        guard let value = snapshot.value! as? String else {
            return
        }
        
        switch snapshot.key {
        case Contact.kContactNameKey:
            self.name = value
            break
        case Contact.kContactJobKey:
            self.job = value
            break
        case Contact.kContactPhoneKey:
            self.phone = value
            break
        default:
            break
        }
    }
    
}

protocol ContactBindible: AnyObject {
    var contact : Contact! {get set}
    var nameLbl: UILabel! {get}
    var nameTxt: UITextField! {get}
    var jobLbl: UILabel! {get}
    var jobTxt: UITextField! {get}
    var phoneLbl: UILabel! {get}
    var phoneTxt: UITextField! {get}
}

extension ContactBindible {
    var nameLbl: UILabel! {return nil}
    var nameTxt: UITextField! {return nil}
    var jobLbl: UILabel! {return nil}
    var jobTxt: UITextField! {return nil}
    var phoneLbl: UILabel! {return nil}
    var phoneTxt: UITextField! {return nil}
    
    func bind(contact: Contact) -> Void {
        self.contact = contact
        self.bind()
    }
    
    func bind() -> Void {
        guard let contact = self.contact else {
            return
        }
        
        if let nameLbl = self.nameLbl {
            nameLbl.text = contact.name
        }
        
        if let nameTxt = self.nameTxt {
            nameTxt.text = contact.name
        }
        if let jobLbl = self.jobLbl {
            jobLbl.text = contact.job
        }
        if let jobTxt = self.jobTxt {
            jobTxt.text = contact.job
        }
        if let phoneLbl = self.phoneLbl {
            phoneLbl.text = contact.phone
        }
        if let phoneTxt = self.phoneTxt {
            phoneTxt.text = contact.phone
        }
        
    }
    
}
