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
    
<<<<<<< Updated upstream
=======
    
    static let kFamilyNameKey = "name"
>>>>>>> Stashed changes
    static let kFamilyIdKey = "id"
    static let kFamilyNameKey = "name"
    static let kFamilyPhotoUrlKey = "photoUrl"
    static let kFamilyMembersKey = "members"
    static let kFamilyAdminKey = "admin"
    static let kFamilyImagePathKey = "imageProfilePath"
    
    let id: String!
<<<<<<< Updated upstream
    var name: String!
    var photoURL: String?
    var imageProfilePath : String?
=======
    let name: String!
    let photoURL: NSURL?
>>>>>>> Stashed changes
    var totalMembers : UInt? = 0
    var admin : String? = ""
    var members : NSDictionary?
    let firebaseReference: FIRDatabaseReference?

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
    
<<<<<<< Updated upstream
    init(name: String, photoURL: String, members: NSDictionary, admin: String, id: String, imageProfilePath: String? ){
=======
    init(name: String, photoURL: NSURL, members: NSDictionary, admin: String, id: String){
>>>>>>> Stashed changes
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
        let snapshotValue = snapshot.value as! [String: Any]
        self.name = snapshotValue[Family.kFamilyNameKey] as! String
        self.id = snapshot.key
        self.imageProfilePath = UTILITY_SERVICE.exist(field: Family.kFamilyImagePathKey, dictionary: snapshotValue as NSDictionary)
        self.photoURL = snapshotValue[Family.kFamilyPhotoUrlKey] as! String
        if let members = snapshotValue[Family.kFamilyMembersKey] {
            self.totalMembers = UInt((members as AnyObject).count)
            self.members = members as? NSDictionary
        }
        if let admin = snapshotValue[Family.kFamilyAdminKey]  {
            self.admin = admin as? String
        }
        self.firebaseReference = snapshot.ref
    }
    
    /* Method to help updating values of an existing object.
     */
    func toDictionary() -> Any {
        return [
            Family.kFamilyNameKey: self.name,
            Family.kFamilyPhotoUrlKey: self.photoURL!,
            Family.kFamilyMembersKey : self.members!,
            Family.kFamilyAdminKey : self.admin ?? "",
            Family.kFamilyImagePathKey: self.imageProfilePath!
        ]
    }
    
    mutating func update(snapshot: FIRDataSnapshot){
        switch snapshot.key {
        case  Family.kFamilyNameKey:
            self.name =  snapshot.value! as! String
            break
        case Family.kFamilyMembersKey:
            self.members = snapshot.value as? NSDictionary
            break
        case Family.kFamilyPhotoUrlKey:
            self.photoURL = snapshot.value as! String
            break
        default:
            break
        }
    }
    
}
