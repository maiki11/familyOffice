//
//  User.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 26/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import Firebase

struct User {
    static let utilityService = Utility.Instance()
    static let kUserNameKey = "name"
    static let kUserIdKey = "id"
    static let kUserPhotoUrlKey = "photoUrl"
    static let kUserFamiliesKey = "families"
    static let kUserFamilyActiveKey = "familyActive"
    static let kUserPhoneKey = "phone"
    static let kUserCurpKey = "curp"
    static let kUserBirthdayKey = "birthday"
    static let kUserAddressKey = "address"
    static let kUserRFCKey = "rfc"
    static let kUserNSSKey = "nss"
    static let kUserBloodTypeKey = "bloodType"
    
    let id: String!
    var name : String!
    var phone: String!
    var photo: Data!
    var photoURL: URL!
    var families : NSDictionary? = nil
    var family: Family? = nil
    var familyActive : String!
    var rfc : String? = ""
    var nss : String? = ""
    var curp : String? = ""
    var birthday: String? = ""
    var address : String? = ""
    var bloodtype: String? = ""
    
    init(id: String, name: String, phone: String, photo: Data, photoURL: String, families: NSDictionary, family : Family, familyActive: String, rfc: String, nss: String, curp: String, birth: String, address: String, bloodtype: String) {
        self.id = id
        self.name = name
        self.phone = phone
        self.photoURL = URL(string: photoURL)
        self.photo =  photo
        self.families = families
        self.family = family
        self.familyActive = familyActive
        self.rfc = rfc
        self.nss = nss
        self.curp = curp
        self.birthday = birth
        self.address = address
        self.bloodtype = bloodtype
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! NSDictionary
        self.name = snapshotValue[User.kUserNameKey] as! String
        self.id = snapshot.key
        let url = User.utilityService.exist(field: User.kUserPhotoUrlKey, dictionary: snapshotValue)
        if (url != "") {
            self.photoURL = URL(string: url)
        }else {
            self.photoURL = nil
        }
        self.familyActive = User.utilityService.exist(field: User.kUserFamilyActiveKey, dictionary: snapshotValue)
        if self.photoURL != nil {
            self.photo = NSData(contentsOf: self.photoURL as URL) as Data?
        }else{
            self.photo = UIImagePNGRepresentation(#imageLiteral(resourceName: "profile_default"))
        }
        
        self.address = User.utilityService.exist(field: User.kUserAddressKey, dictionary: snapshotValue )
        self.birthday = User.utilityService.exist(field: User.kUserAddressKey, dictionary: snapshotValue )
        self.curp = User.utilityService.exist(field: User.kUserCurpKey, dictionary: snapshotValue)
        self.rfc = User.utilityService.exist(field: User.kUserRFCKey, dictionary: snapshotValue)
        self.nss = User.utilityService.exist(field: User.kUserNSSKey, dictionary: snapshotValue)
        self.bloodtype = User.utilityService.exist(field: User.kUserBloodTypeKey, dictionary: snapshotValue)
        self.families = User.utilityService.existNSDictionary(field: User.kUserFamiliesKey, dictionary: snapshotValue)
        self.phone = User.utilityService.exist(field: User.kUserPhoneKey, dictionary: snapshotValue)
    }
    
    func toDictionary() -> NSDictionary {
        return [
            User.kUserNameKey: self.name,
            User.kUserPhotoUrlKey: self.photoURL!.absoluteString,
            User.kUserFamilyActiveKey: self.familyActive!,
            User.kUserRFCKey: self.rfc ?? "Desconocido",
            User.kUserCurpKey: self.curp ?? "Desconocida",
            User.kUserAddressKey: self.address ?? "Desconocida",
            User.kUserNSSKey: self.nss ?? "Desconocido",
            User.kUserBloodTypeKey: self.bloodtype ?? "Desconocido"
        ]
    }
    
    
}
