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
   
    public var user : User? = nil
    public var users: [User] = []
    private init(){
    }
    public static func Instance() -> UserService {
        return instance
    }
    
    private static let instance : UserService = UserService()
   
    func setFamily(family: Family) -> Void {
        user?.family = family
        user?.familyActive = family.id
    }
    
    func getUser(uid: String, mainly: Bool) -> Void {
        REF.child("/users/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists()){
                let user = User(snapshot: snapshot)
                if(mainly){
                    self.user = user
                }
                if(self.duplicate(id:user.id)){
                    self.users.append(User(snapshot: snapshot))
                    NotificationCenter.default.post(name: USERS_NOTIFICATION, object: nil)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func getUser(email: String) -> Void {
        REF.child("/users/").queryOrderedByValue().queryEqual(toValue: email).observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists()){
                let user = User(snapshot: snapshot)
                if(self.duplicate(id:user.id)){
                    self.users.append(User(snapshot: snapshot))
                    NotificationCenter.default.post(name: USERS_NOTIFICATION, object: user)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func getUser(phone: String) -> Void {
        REF.child("users").queryOrdered(byChild: "phone").queryStarting(atValue: phone).queryEnding(atValue: phone).observe(.childAdded, with: { (snapshot) -> Void in
            if(snapshot.exists()){
                let user = User(snapshot: snapshot)
                if(self.duplicate(id:user.id)){
                    self.users.append(User(snapshot: snapshot))
                    NotificationCenter.default.post(name: USERS_NOTIFICATION, object: user)
                }
            }

        })
    }
    
    func changePassword(oldPass: String, newPass: String) -> Void {
        let user = FIRAuth.auth()?.currentUser
        FIRAuth.auth()?.signIn(withEmail: (user?.email)!, password: oldPass) { (user, error) in
            if((error) != nil){
                print(error.debugDescription)
            }else{
                user?.updatePassword(newPass) { error in
                    if let error = error {
                        NotificationCenter.default.post(name: ERROR_NOTIFICATION, object: nil)
                        print(error.localizedDescription)
                    } else {
                        
                        ACTIVITYLOG_SERVICE.create(id: (self.user?.id)!, activity: "Se cambio contraseña", photo: (self.user?.photoURL)!, type: "personalInfo")
                        NotificationCenter.default.post(name: SUCCESS_NOTIFICATION, object: nil)
                    }
                }
            }
        }
    }
    
    func updateUser(user: User) -> Void {
        REF_USERS.child(user.id).updateChildValues(user.toDictionary() as! [AnyHashable : Any])
        ACTIVITYLOG_SERVICE.create(id: (self.user?.id)!, activity: "Se actualizo información personal", photo: (self.user?.photoURL)!, type: "personalInfo")
        self.user = user
    }
    
    
    
    internal func searchUser(uid: String)->User?{
        for item in self.users {
            if(item.id == uid){
                return item
            }
        }
        return nil
    }
    
    func searchUser(phone: String) -> User? {
        for item in self.users {
            if(item.phone == phone){
                return item
            }
        }
        return nil
    }
    
    func searchUser(email: String) -> User? {
        for item in self.users {
            if(item.phone == email){
                return item
            }
        }
        return nil
    }
    
    internal func clearData() {
        self.user = nil
        self.users.removeAll()
    }
    
    private func removeUser(user: User) -> Void {
        var cont = 0
        for item in self.users {
            if(item.id == user.id){
                self.users.remove(at: cont)
            }
            cont += 1
        }
    }
    func duplicate(id: String) -> Bool {
        var bool = true
        for item in self.users {
            if(item.id == id){
                bool = false
                break
            }
        }
        return bool
    }
}
