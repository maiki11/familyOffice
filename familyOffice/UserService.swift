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
    public var users: [User] = []
    
    private init(){
    }
    public static func Instance() -> UserService {
        return instance
    }
    
    private static let instance : UserService = UserService()
    
    func setFamily(family: Family) -> Void {
        //user?.family = family
        users[0].familyActive = family.id
    }
    
    func getUser(uid: String) -> Void {
        Constants.FirDatabase.REF.child("/users/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists()){
                self.addUser(user:  User(snapshot: snapshot))
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func getUser(email: String) -> Void {
        Constants.FirDatabase.REF.child("/users/").queryOrderedByValue().queryEqual(toValue: email).observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists()){
                self.addUser(user:  User(snapshot: snapshot))
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func getUser(phone: String) -> Void {
        Constants.FirDatabase.REF_USERS.queryOrdered(byChild: "phone").queryStarting(atValue: "\(phone)").queryEnding(atValue: "\(phone)").observe(.childAdded, with: { (snapshot) -> Void in
            if(snapshot.exists()){
                self.addUser(user:  User(snapshot: snapshot))
                Constants.FirDatabase.REF_USERS.removeAllObservers()
                return
            }
            
        })
    }
    func changePassword(oldPass: String, newPass: String, context: UIViewController) -> Void {
        let user = FIRAuth.auth()?.currentUser
        FIRAuth.auth()?.signIn(withEmail: (user?.email)!, password: oldPass) { (user, error) in
            if((error) != nil){
                Constants.Services.ALERT_SERVICE.alertMessage(context: context, title: "Error en contraseña", msg: "La contraseña anterior no es válida")
                //print(error.debugDescription)
            }else{
                user?.updatePassword(newPass) { error in
                    if let error = error {
                        NotificationCenter.default.post(name: Constants.NotificationCenter.ERROR_NOTIFICATION, object: nil)
                        print(error.localizedDescription)
                    } else {
                        
                        Constants.Services.ACTIVITYLOG_SERVICE.create(id: self.users[0].id, activity: "Se cambio contraseña", photo: self.users[0].photoURL, type: "personalInfo")
                        NotificationCenter.default.post(name: Constants.NotificationCenter.SUCCESS_NOTIFICATION, object: nil)
                    }
                }
            }
        }
    }
    func updated(snapshot: FIRDataSnapshot, uid: String) -> Void {
        if let index = self.users.index(where: { $0.id == uid }){
            self.users[index].update(snapshot: snapshot)
            NotificationCenter.default.post(name: Constants.NotificationCenter.USERUPDATED_NOTIFICATION, object: self.users[index].id)
        }
    }
    
    func updateUser(user: User) -> Void {
        Constants.FirDatabase.REF_USERS.child(user.id).updateChildValues(user.toDictionary() as! [AnyHashable : Any])
        Constants.Services.ACTIVITYLOG_SERVICE.create(id: (self.users[0].id)!, activity: "Se actualizo información personal", photo: (self.users[0].photoURL)!, type: "personalInfo")
        self.users[0] = user
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
    
    internal func addUser(user: User)-> Void{
        if !self.users.contains(where: {$0.id == user.id}) {
            self.users.append(user)
            if FIRAuth.auth()?.currentUser?.uid == user.id {
                Constants.Services.NOTIFICATION_SERVICE.saveToken()
                if let families = user.families?.allKeys {
                    for id in families {
                        Constants.Services.REF_SERVICE.valueSingleton(ref: "families/\((id))")
                    }
                }
                Constants.Services.REF_SERVICE.chilAdded(ref: "users/\((FIRAuth.auth()?.currentUser?.uid)!)/families")
                Constants.Services.REF_SERVICE.chilRemoved(ref: "users/\((FIRAuth.auth()?.currentUser?.uid)!)/families")
                if(self.users[0].families?.count == 0 ){
                    NotificationCenter.default.post(name: Constants.NotificationCenter.NOFAMILIES_NOTIFICATION, object: nil)
                }
            }
            NotificationCenter.default.post(name: Constants.NotificationCenter.USER_NOTIFICATION, object: user)
        }else{
            if let index = self.users.index(where: {$0.id == user.id}) {
                self.users[index] = user
                NotificationCenter.default.post(name: Constants.NotificationCenter.USER_NOTIFICATION, object: user)
            }
        }
    }
    
}
