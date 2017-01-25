//
//  UserModel.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 05/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct usermodel {
    let name : String
    let phone: String
    let photo: NSData
    let families : [Family]
    let family : Family?
}

class User {
    var userDefaults: UserDefaults
    public static let user = User()
    private init(){
        userDefaults = UserDefaults.standard
    }
    public static func Instance() -> User {
        return instance
    }
    
    static let instance : User = User()
    
    func fillData(user: usermodel) {
        userDefaults.set(user.name, forKey: "name")
        userDefaults.set(user.phone, forKey: "phone")
        userDefaults.set(user.photo, forKey: "photo")
        userDefaults.set(user.families, forKey: "families")
    }
    func setFamily(family: Family, photoData: Data) -> Void {
        userDefaults.setValue(family.id, forKeyPath: "familyId")
        userDefaults.setValue(family.name, forKeyPath: "familyName")
        userDefaults.setValue(photoData, forKeyPath: "familyPhoto")
    }
    
    func getData() -> usermodel {
        let family = Family()
        family.name = exist(field: "familyName")
        family.id = exist(field: "familyId")
        family.photo = UIImage(data: existData(field: "familyPhoto")!)
        let xuser = usermodel(
            name: (exist(field: "name")! as String) , phone: (exist(field: "phone")! as String) , photo: (existData(field: "photo"))! as NSData, families: (existArray(field: "families") as! Array<Family>), family: family)
        return xuser
    }
    
    
    func clearData() {
        userDefaults.removeObject(forKey: "name")
        userDefaults.removeObject(forKey: "photo")
        userDefaults.removeObject(forKey: "phone")
        userDefaults.removeObject(forKey: "families")
        userDefaults.removeObject(forKey: "familyId")
        userDefaults.removeObject(forKey: "familyName")
        userDefaults.removeObject(forKey: "familyPhoto")
    }
    
    private func exist(field: String) -> String? {
        if let value = userDefaults.string(forKey: field) {
            return value
        }else {
            return ""
        }
    }
    private func existData(field: String) -> Data? {
        if let value = userDefaults.data(forKey: field) {
            return value
        }else {
            return UIImagePNGRepresentation(#imageLiteral(resourceName: "Profile2") )
        }
    }
    private func existArray(field: String) -> [Any] {
        if let value = userDefaults.array(forKey: field) {
            return value
        }else {
            return []
        }
    }
    
    
}
