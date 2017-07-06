//
//  family.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 06/01/17.
//  Copyright © 2017 Miguel Reina y Leonardo Durazo. All rights reserved.
//

import Foundation
import Firebase

struct Family  {
    
    static let kFamilyIdKey = "id"
    static let kFamilyNameKey = "name"
    static let kFamilyPhotoUrlKey = "photoUrl"
    static let kFamilyMembersKey = "members"
    static let kFamilyAdminKey = "admin"
    static let kFamilyImagePathKey = "imageProfilePath"
    
    let id: String!
    var name: String!
    var photoURL: String?
    var imageProfilePath : String?
    var totalMembers : UInt? = 0
    var admin : String? = ""
    var members : [String]!
    let firebaseReference: FIRDatabaseReference?
    var goals: [Goal]! = []
    /* Initializer for instantiating a new object in code.
     */
    init(name: String, photo: Data, id: String){
        self.name = name
        self.photoURL = nil
        self.admin = ""
        self.totalMembers = 0
        self.firebaseReference = nil
        self.id = id
        self.members = nil
    }
    
    init(name: String, photoURL: String, members: [String], admin: String, id: String, imageProfilePath: String? ){
        self.name = name
        self.photoURL = photoURL
        self.admin = admin
        self.totalMembers = 0
        self.firebaseReference = nil
        self.id = id
        self.members = members
        self.imageProfilePath = imageProfilePath
    }
    
    /* Initializer for instantiating an object received from Firebase.
     */
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! NSDictionary
        self.id = snapshot.key
        self.name = service.UTILITY_SERVICE.exist(field: Family.kFamilyNameKey, dictionary: snapshotValue)
        self.imageProfilePath = service.UTILITY_SERVICE.exist(field: Family.kFamilyImagePathKey, dictionary: snapshotValue)
        self.photoURL = service.UTILITY_SERVICE.exist(field: Family.kFamilyPhotoUrlKey, dictionary: snapshotValue)
        self.members = service.UTILITY_SERVICE.exist(field: Family.kFamilyMembersKey, dictionary: snapshotValue)
        self.admin = service.UTILITY_SERVICE.exist(field: Family.kFamilyAdminKey, dictionary: snapshotValue)
        self.firebaseReference = snapshot.ref
    }
    
    /* Method to help updating values of an existing object.
     */
    func toDictionary() -> Any {
        
        
        return [
            Family.kFamilyNameKey: self.name,
            Family.kFamilyPhotoUrlKey: self.photoURL!,
            Family.kFamilyMembersKey : service.UTILITY_SERVICE.toDictionary(array: self.members),
            Family.kFamilyAdminKey : self.admin ?? "",
            Family.kFamilyImagePathKey: self.imageProfilePath!
        ]
    }
    
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
    }
    
}
