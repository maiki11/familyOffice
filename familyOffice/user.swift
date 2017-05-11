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
    
    static let kUserNameKey = "name"
    static let kUserIdKey = "id"
    static let kUserPhotoUrlKey = "photoUrl"
    static let kUserFamiliesKey = "families"
    static let kEventKey = "events"
    static let kUserFamilyActiveKey = "familyActive"
    static let kUserPhoneKey = "phone"
    static let kUserCurpKey = "curp"
    static let kUserBirthdayKey = "birthday"
    static let kUserAddressKey = "address"
    static let kUserRFCKey = "rfc"
    static let kUserNSSKey = "nss"
    static let kUserBloodTypeKey = "bloodType"
    static let kUserTokensFCMeKey = "tokensFCM"
    static let kUserHealthKey = "health"
    
    let id: String!
    var name : String!
    var phone: String!
    var photoURL: String!
    var families : NSDictionary? = nil
    var familyActive : String!
    var rfc : String!
    var nss : String!
    var curp : String!
    var birthday: String!
    var address : String!
    var bloodtype: String!
    var tokens: NSDictionary? = nil
    var events: [String]? = []
    var health: Health

    
    init(id: String, name: String, phone: String,  photoURL: String, families: NSDictionary, familyActive: String, rfc: String, nss: String, curp: String, birth: String, address: String, bloodtype: String, health: NSArray) {
        self.id = id
        self.name = name
        self.phone = phone
        self.photoURL = photoURL
        self.families = families
        self.familyActive = familyActive
        self.rfc = rfc
        self.nss = nss
        self.curp = curp
        self.birthday = birth
        self.address = address
        self.bloodtype = bloodtype
        self.tokens = nil
        self.health = Health(array: health)
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! NSDictionary
        self.name = Constants.Services.UTILITY_SERVICE.exist(field: User.kUserNameKey, dictionary: snapshotValue)
        self.id = snapshot.key
        self.photoURL = Constants.Services.UTILITY_SERVICE.exist(field: User.kUserPhotoUrlKey, dictionary: snapshotValue)
        self.familyActive = Constants.Services.UTILITY_SERVICE.exist(field: User.kUserFamilyActiveKey, dictionary: snapshotValue)
        self.address = Constants.Services.UTILITY_SERVICE.exist(field: User.kUserAddressKey, dictionary: snapshotValue )
        self.birthday = Constants.Services.UTILITY_SERVICE.exist(field: User.kUserBirthdayKey, dictionary: snapshotValue )
        self.curp = Constants.Services.UTILITY_SERVICE.exist(field: User.kUserCurpKey, dictionary: snapshotValue)
        self.rfc = Constants.Services.UTILITY_SERVICE.exist(field: User.kUserRFCKey, dictionary: snapshotValue)
        self.nss = Constants.Services.UTILITY_SERVICE.exist(field: User.kUserNSSKey, dictionary: snapshotValue)
        self.bloodtype = Constants.Services.UTILITY_SERVICE.exist(field: User.kUserBloodTypeKey, dictionary: snapshotValue)
        self.families = Constants.Services.UTILITY_SERVICE.exist(field: User.kUserFamiliesKey, dictionary: snapshotValue)
        self.phone = Constants.Services.UTILITY_SERVICE.exist(field: User.kUserPhoneKey, dictionary: snapshotValue)
        self.tokens = Constants.Services.UTILITY_SERVICE.exist(field: User.kUserTokensFCMeKey, dictionary: snapshotValue)
        self.events = Constants.Services.UTILITY_SERVICE.exist(field: User.kEventKey, dictionary: snapshotValue)
        self.health = Health(snapshot: snapshot.childSnapshot(forPath: "health"))

    }
    
    func toDictionary() -> NSDictionary {
        return [
            User.kUserNameKey : self.name!,
            User.kUserPhotoUrlKey : self.photoURL!,
            User.kUserFamilyActiveKey: self.familyActive!,
            User.kUserRFCKey: self.rfc!,
            User.kUserCurpKey: self.curp!,
            User.kUserAddressKey: self.address!,
            User.kUserNSSKey: self.nss!,
            User.kUserBloodTypeKey: self.bloodtype!,
            User.kUserPhoneKey : self.phone!,
            User.kUserBirthdayKey : self.birthday!,
            User.kUserHealthKey : self.health.toDictionary()
        ]
    }
    
    mutating func update(snapshot: FIRDataSnapshot){
        switch snapshot.key {
        case  User.kUserPhotoUrlKey:
            self.photoURL =  snapshot.value! as! String
            break
        case User.kUserFamiliesKey:
            self.families = snapshot.value! as? NSDictionary
            break
        case User.kUserHealthKey:
            self.health = Health(snapshot: snapshot)
        default:
            break
        }
    }
}

protocol UserModelBindable: AnyObject {
    var userModel: User? { get set }
    var filter: String! { get set}
    var nameLabel: UILabel! {get}
    var profileImage: UIImageView! {get}
    
}

extension UserModelBindable {
    // Make the views optionals
    
    var nameLabel: UILabel! {
        return nil
    }
    
    var profileImage: UIImageView! {
        return nil
    }
    
  
    
    // Bind
    
    func bind(userModel: User, filter: String = "") {
        self.userModel = userModel
        self.filter = filter
        bind()
    }
    
    func bind() {
        
        guard let userModel = self.userModel else {
            return
        }
        
        if let nameLabel = self.nameLabel {
            nameLabel.text = userModel.name
        }
        
        if let profileImage = self.profileImage {
            if !userModel.photoURL.isEmpty {
                profileImage.loadImage(urlString: userModel.photoURL, filter: filter)
            }else{
                profileImage.image = #imageLiteral(resourceName: "profile_default")
            }
        }
        
        
    }
}

