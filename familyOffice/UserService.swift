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



class UserService {
    var userDefaults: UserDefaults
    public var user : User? = nil
    private init(){
        userDefaults = UserDefaults.standard
    }
    public static func Instance() -> UserService {
        return instance
    }
    
    static let instance : UserService = UserService()
    
    func fillData(user: User) {
        userDefaults.set(user.name, forKey: "name")
        userDefaults.set(user.phone, forKey: "phone")
        userDefaults.set(user.photo, forKey: "photo")
        userDefaults.set(user.families, forKey: "families")
        //NotificationCenter.default.post(name: USER_NOTIFICATION, object: nil)
    }
    func setFamily(family: Family) -> Void {
        userDefaults.setValue(family.id, forKeyPath: "familyId")
        userDefaults.setValue(family.name, forKeyPath: "familyName")
        userDefaults.setValue(family.photoData, forKeyPath: "familyPhoto")
        NotificationCenter.default.post(name: USER_NOTIFICATION, object: nil)
    }
    
    func getUser(uid: String) -> Void {
        REF.child("/users/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists()){
                self.user = User(snapshot: snapshot)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
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
